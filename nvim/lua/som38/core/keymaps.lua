local M = {}

M.setup = function()
	vim.g.mapleader = " "

	-- disable predefined mappings
	vim.g.pswitcher_no_default_key_mappings = 1

	local keymap = vim.keymap -- for conciseness

	-- general keymaps
	keymap.set("n", "<C-u>", "<C-u>zz")
	keymap.set("n", "<C-d>", "<C-d>zz")
	keymap.set("n", "z.", "zszH")
	keymap.set("i", "<C-a>", "<Home>")
	keymap.set("i", "<C-e>", "<End>")

	-- increment/decrement numbers
	keymap.set("n", "+", "<C-a>") -- increment
	keymap.set("n", "-", "<C-x>") -- decrement

	-- easier blackhole
	keymap.set("n", "_", '"_')

	-- window management
	keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
	keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
	keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
	keymap.set("n", "<leader>sm", "<C-w>_") -- make split windows equal width & height
	keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
	keymap.set("n", "<leader>so", "<C-w>o") -- close everything but current split window

	keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
	keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
	keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
	keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

	-- file copy
	keymap.set("n", "<leader>ct", ":let @+ = expand('%:t')<CR>") -- copy file name without path
	keymap.set("n", "<leader>cn", ":let @+ = expand('%:p')<CR>") -- copy file name with path
	keymap.set("n", "<leader>cp", ":let @+ = expand('%:h')<CR>") -- copy file path without name

	-- Oil
	keymap.set("n", "<leader>-", "<CMD>Oil<CR>")
end

return M
