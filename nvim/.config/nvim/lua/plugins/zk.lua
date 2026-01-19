return {
	"zk-org/zk-nvim",
	config = function()
		require("zk").setup({
			picker_options = {
				snacks_picker = {
					layout = {
						preset = "ivy",
					},
				},
			},
		})
	end,
}
