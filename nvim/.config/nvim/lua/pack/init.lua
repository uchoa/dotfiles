local function load_plugin(name, spec)
  vim.cmd("packadd " .. name)
  if spec.config then
    pcall(spec.config)
  end
end

local function setup_lazy(name, spec)
  if spec.event then
    local events = type(spec.event) == "table" and spec.event or { spec.event }
    vim.api.nvim_create_autocmd(events, {
      once = true,
      callback = function()
        load_plugin(name, spec)
      end
    })
  end

  if spec.ft then
    local fts = type(spec.ft) == "table" and spec.ft or { spec.ft }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = fts,
      once = true,
      callback = function()
        load_plugin(name, spec)
      end
    })
  end

  if spec.cmd then
    local cmds = type(spec.cmd) == "table" and spec.cmd or { spec.cmd }
    for _, cmd in ipairs(cmds) do
      vim.api.nvim_create_user_command(cmd, function(args)
        vim.api.nvim_del_user_command(cmd)
        load_plugin(name, spec)
        vim.cmd(cmd .. " " .. args.args)
      end, { nargs = "*", bang = true })
    end
  end

  if spec.keys then
    local keys = type(spec.keys) == "table" and spec.keys or {}
    for _, key in ipairs(keys) do
      if type(key) == "table" then
        local mode = key.mode or "n"
        local lhs = key[1]
        if lhs then
          vim.keymap.set(mode, lhs, function()
            vim.keymap.del(mode, lhs)
            load_plugin(name, spec)
            if type(key[2]) == "function" then
              key[2]()
            elseif type(key[2]) == "string" then
              vim.cmd(key[2])
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(lhs, true, true, true), "m", true)
            end
          end, { desc = key.desc })
        end
      end
    end
  end
end
local all_specs = {}

local function run_build(name, spec)
  if not (spec and spec.build) then
    return
  end
  pcall(vim.cmd, "packadd " .. name)
  if type(spec.build) == "function" then
    local ok, err = pcall(spec.build)
    if not ok then
      vim.notify("Build failed for " .. name .. ": " .. tostring(err), vim.log.levels.ERROR)
    else
      vim.notify("Build succeeded for " .. name, vim.log.levels.INFO)
    end
  elseif type(spec.build) == "string" then
    local out = vim.fn.system(spec.build)
    if vim.v.shell_error ~= 0 then
      vim.notify("Build failed for " .. name .. ": " .. out, vim.log.levels.ERROR)
    else
      vim.notify("Build succeeded for " .. name, vim.log.levels.INFO)
    end
  end
end

local function load_all()
  local plugin_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins", "**/*.lua", false, true)

  local startup_specs = {}
  local lazy_specs = {}

  for _, file in ipairs(plugin_files) do
    local modname = file:match("lua/(.*)%.lua$"):gsub("/", ".")
    local ok, spec = pcall(require, modname)
    if ok and type(spec) == "table" then
      if spec.src then
        spec.name = spec.name or spec.src:match("([^/]+)$"):gsub("%.git$", "")
        all_specs[spec.name] = spec

        local is_lazy = spec.event or spec.ft or spec.cmd or spec.keys
        if is_lazy then
          table.insert(lazy_specs, spec)
        else
          table.insert(startup_specs, spec)
        end
      elseif spec.config then
        -- Local/standalone module (e.g. lsp.lua) that needs no package downloading
        pcall(spec.config)
      end
    end
  end
  if vim.pack and vim.pack.add then
    if #startup_specs > 0 then
      vim.pack.add(startup_specs, { confirm = false, load = true })
      for _, spec in ipairs(startup_specs) do
        if spec.config then
          pcall(spec.config)
        end
      end
    end

    if #lazy_specs > 0 then
      vim.pack.add(lazy_specs, { confirm = false, load = false })
      for _, spec in ipairs(lazy_specs) do
        setup_lazy(spec.name, spec)
      end
    end
  else
    for _, spec in ipairs(startup_specs) do
      load_plugin(spec.name, spec)
    end
    for _, spec in ipairs(lazy_specs) do
      setup_lazy(spec.name, spec)
    end
  end
end

vim.api.nvim_create_augroup("PackBuildHooks", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  group = "PackBuildHooks",
  callback = function(args)
    local data = args.data
    if data and (data.kind == "install" or data.kind == "update") then
      local name = data.spec and data.spec.name or data.plugin_name or data.name
      local spec = name and all_specs[name]
      if spec and spec.build then
        run_build(name, spec)
      end
    end
  end,
})

vim.api.nvim_create_user_command("PackBuild", function(opts)
  local target = opts.args ~= "" and opts.args or nil
  if target then
    local spec = all_specs[target]
    if spec and spec.build then
      run_build(target, spec)
    else
      vim.notify("No build hook defined for " .. target, vim.log.levels.WARN)
    end
  else
    local built_any = false
    for name, spec in pairs(all_specs) do
      if spec.build then
        built_any = true
        run_build(name, spec)
      end
    end
    if not built_any then
      vim.notify("No build hooks found across plugins", vim.log.levels.INFO)
    end
  end
end, {
  nargs = "?",
  complete = function(arg_lead)
    local matches = {}
    for name, spec in pairs(all_specs) do
      if spec.build and name:find("^" .. vim.pesc(arg_lead)) then
        table.insert(matches, name)
      end
    end
    return matches
  end,
})

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  if vim.pack and vim.pack.update then
    local names = #opts.fargs > 0 and opts.fargs or nil
    vim.pack.update(names)
  else
    vim.notify("vim.pack.update not available", vim.log.levels.ERROR)
  end
end, {
  nargs = "*",
  complete = function(arg_lead)
    local pkgs = vim.pack and vim.pack.get and vim.pack.get() or {}
    local names = {}
    for _, pkg in ipairs(pkgs) do
      if pkg.spec and pkg.spec.name and pkg.spec.name:find("^" .. vim.pesc(arg_lead)) then
        table.insert(names, pkg.spec.name)
      end
    end
    return names
  end,
})

vim.api.nvim_create_user_command("PackStatus", function()
  if vim.pack and vim.pack.get then
    local pkgs = vim.pack.get()
    print(vim.inspect(pkgs))
  else
    vim.notify("vim.pack.get not available", vim.log.levels.ERROR)
  end
end, {})

load_all()
