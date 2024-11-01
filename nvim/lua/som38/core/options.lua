local M = {}

M.setup = function()
	local opt = vim.opt -- for conciseness

	-- yql/arcadia pog
	vim.g.sql_type_default = "yql"

	-- default terminal
	vim.g.terminal_emulator = "/bin/zsh"

	-- line numbers
	opt.relativenumber = true
	opt.number = true
	opt.showmode = true

	-- opt.guicursor = "n-v-c-i:block-Cursor"
	-- tabs & identation
	opt.tabstop = 2
	opt.shiftwidth = 2
	opt.expandtab = true
	opt.autoindent = true

	-- line wrapping
	opt.wrap = false
	opt.colorcolumn = "80"

	-- search settings
	opt.ignorecase = true
	opt.smartcase = true

	-- cursor line
	opt.cursorline = true

	-- appearance
	opt.termguicolors = true
	opt.background = "dark"
	opt.signcolumn = "yes"

	-- backspace
	opt.backspace = "indent,eol,start"

	-- clipboard
	opt.clipboard:append("unnamedplus")

	-- split windows
	opt.splitright = true
	opt.splitbelow = true

	opt.iskeyword:append("-")
end

return M
