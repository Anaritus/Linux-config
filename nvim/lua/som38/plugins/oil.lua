return {
	-- oil
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		keymaps = {
			["<C-h>"] = false,
			["<C-l>"] = false,
		},
		experimental_watch_for_changes = true,
	},
}
