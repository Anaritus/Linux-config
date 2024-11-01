function P(v)
	print(vim.inspect(v))
	return v
end
-- dev keymaps
local keymap = vim.keymap
keymap.set("n", "<leader><leader>r", "<cmd>w | source %<cr>")
keymap.set("n", "<leader><leader>x", "<cmd>source %<cr>")
