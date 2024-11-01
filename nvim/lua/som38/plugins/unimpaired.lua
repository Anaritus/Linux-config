-- cool mappings
return {
	"tpope/vim-unimpaired",
	config = function()
		local keymap = vim.keymap
		keymap.set("n", "<leader>dk", ':norm ]n"_d]n[n"_dd[n"_dd<cr>')
		keymap.set("n", "<leader>dj", ':norm "_d]n"_dd]n"_dd<cr>')
		keymap.set("n", "<leader>d<space>", ":norm [<space>]<space><cr>")
	end,
}
