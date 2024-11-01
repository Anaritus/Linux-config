-- harpoon man
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	keys = {
		"<leader>a",
		"<C-e>",
		"<Down>",
		"<Up>",
		"<Left>",
		"<Right>",
	},
	config = function()
		local harpoon = require("harpoon")

		harpoon.setup({})

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list(), {
				border = "rounded",
				title_pos = "center",
			})
		end)

		vim.keymap.set("n", "<Down>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<Up>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<Left>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<Right>", function()
			harpoon:list():select(4)
		end)
	end,
}
