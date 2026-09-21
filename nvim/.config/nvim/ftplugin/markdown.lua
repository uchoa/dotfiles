vim.opt_local.textwidth = 80
vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = 0,
	callback = function()
		pcall(vim.cmd, "TableTidyAll")
	end,
})

_G.mdv_preview_instances = _G.mdv_preview_instances or {}

function _G.StopMdvPreview(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local info = _G.mdv_preview_instances[bufnr]
	if not info then
		return
	end
	_G.mdv_preview_instances[bufnr] = nil

	if info.augroup then
		pcall(vim.api.nvim_del_augroup_by_id, info.augroup)
	end

	if info.job_id then
		pcall(vim.fn.jobstop, info.job_id)
	end

	if info.temp_path and vim.fn.filereadable(info.temp_path) == 1 then
		pcall(vim.fn.delete, info.temp_path)
	end
	if info.temp_dir and vim.fn.isdirectory(info.temp_dir) == 1 then
		pcall(vim.fn.delete, info.temp_dir, "d")
	end
end

local function get_mdv_cmd(file_path)
	local matches = vim.fn.glob(vim.fn.expand("~/.cache/mdv/gui/*/mdv"), false, true)
	if #matches == 0 then
		vim.fn.system({ "mdv", "--gui", "--version" })
		matches = vim.fn.glob(vim.fn.expand("~/.cache/mdv/gui/*/mdv"), false, true)
	end

	if #matches > 0 then
		table.sort(matches)
		return { matches[#matches], file_path }
	end

	return { "mdv", "--gui", file_path }
end

function _G.ToggleMdvPreview()
	local bufnr = vim.api.nvim_get_current_buf()
	if _G.mdv_preview_instances[bufnr] then
		_G.StopMdvPreview(bufnr)
		return
	end

	local file_path = vim.api.nvim_buf_get_name(bufnr)
	local cwd = file_path ~= "" and vim.fn.fnamemodify(file_path, ":p:h") or vim.fn.getcwd()
	local base_name = file_path ~= "" and vim.fn.fnamemodify(file_path, ":t") or "preview.md"
	local temp_dir = vim.fn.tempname()
	vim.fn.mkdir(temp_dir, "p")
	local temp_path = temp_dir .. "/" .. base_name

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	vim.fn.writefile(lines, temp_path)

	local cmd = get_mdv_cmd(temp_path)
	local job_id
	job_id = vim.fn.jobstart(cmd, {
		detach = true,
		cwd = cwd,
		env = {
			MDV_STDIN_TEMP = temp_path,
		},
		on_exit = function()
			vim.schedule(function()
				local info = _G.mdv_preview_instances[bufnr]
				if info and info.job_id == job_id then
					_G.StopMdvPreview(bufnr)
				end
			end)
		end,
	})

	if job_id <= 0 then
		vim.notify("MDV Preview: Failed to start mdv", vim.log.levels.ERROR)
		pcall(vim.fn.delete, temp_path)
		pcall(vim.fn.delete, temp_dir, "d")
		return
	end

	local augroup = vim.api.nvim_create_augroup("MdvPreview_" .. bufnr, { clear = true })
	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout", "BufUnload" }, {
		group = augroup,
		buffer = bufnr,
		once = true,
		callback = function()
			_G.StopMdvPreview(bufnr)
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "CursorHold", "CursorHoldI", "BufWritePost" }, {
		group = augroup,
		buffer = bufnr,
		callback = function()
			if vim.api.nvim_buf_is_valid(bufnr) and vim.fn.filereadable(temp_path) == 1 then
				local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				vim.fn.writefile(current_lines, temp_path)
			end
		end,
	})

	_G.mdv_preview_instances[bufnr] = {
		job_id = job_id,
		augroup = augroup,
		temp_path = temp_path,
		temp_dir = temp_dir,
	}
end

vim.keymap.set("n", "<C-p>", function()
	_G.ToggleMdvPreview()
end, { buffer = true, desc = "Toggle Markdown Preview (mdv)" })
