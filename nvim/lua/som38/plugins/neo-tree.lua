-- file explorer
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	keys = "<leader>e",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		local neo_tree = require("neo-tree")
		neo_tree.setup({
			popup_border_style = "rounded",
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
				},
			},
		})
		local keymap = vim.keymap
		keymap.set("n", "<leader>e", ":Neotree right<CR>") -- toggle file explorer
	end,
}
