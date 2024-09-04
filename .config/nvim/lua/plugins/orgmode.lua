return {
	'nvim-orgmode/orgmode',
	event = 'VeryLazy',
	ft = { 'org' },
	dependencies = {
		{
			'akinsho/org-bullets.nvim',
			config = function()
				require('org-bullets').setup()
			end,
		}
	},
	config = function()
		-- Setup orgmode
		require('orgmode').setup({
			org_agenda_files = '~/notes/**/*',
			org_default_notes_file = '~/notes/refile.org',
		})
	end,
}
