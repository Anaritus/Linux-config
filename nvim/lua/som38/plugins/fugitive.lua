return {
	"tpope/vim-fugitive",
	config = function()
		local keymap = vim.keymap
		keymap.set("n", "gj", "<cmd>diffget //2<cr>")
		keymap.set("n", "gk", "<cmd>diffget //3<cr>")
	end,
}
