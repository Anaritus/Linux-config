return {
	"AckslD/swenv.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local swenv = require("swenv.api")

		local keymap = vim.keymap
		local opts = { noremap = true, silent = true }

		opts.desc = "pick venv"
		keymap.set("n", "<leader>sp", function()
			swenv.pick_venv()
		end, opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "python" },
			callback = function()
				swenv.set_venv("work")
			end,
		})
	end,
}
