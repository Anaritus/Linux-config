return {
	-- DadBod
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	keys = "<leader>dbt",
	config = function()
		local keymap = vim.keymap
		keymap.set("n", "<leader>dbt", ":DBUIToggle<CR>")
	end,
}
