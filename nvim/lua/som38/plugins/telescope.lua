-- fuzzy finding w/ telescope
return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")

		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.load_extension("fzf")
		-- configure telescope
		telescope.setup({
			-- configure custom mappings
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
					},
				},
			},
			extensions = {
				arc = {
					mappings = {
						i = {
							staging_add_all = "<c-b>a",
							staging_reset_all = "<c-b>u",
							staging_toggle = "<c-t>",
						},
					},
				},
			},
		})
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>ff", builtin.find_files) -- find files within current working directory, respects .gitignore
		keymap.set("n", "<leader>fg", "<cmd>Telescope find_files no_ignore=true<cr>") -- find files within current working directory, respects .gitignore
		keymap.set("n", "<leader>fs", builtin.live_grep) -- find string in current working directory as you type
		keymap.set("n", "<leader>fb", builtin.buffers) -- list open buffers in current neovim instance
		keymap.set("n", "<leader>fh", builtin.help_tags) -- list available help tags
	end,
} -- fuzzy finder
