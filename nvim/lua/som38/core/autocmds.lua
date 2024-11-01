local M = {}

M.setup = function()
	local group = vim.api.nvim_create_augroup("text_autocommands", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		pattern = { "*.md", "*.txt", "*.tex" },
		callback = function()
			-- actual mapping
			-- I don't know why I need this.
			vim.opt.tabstop = 2
			vim.opt.shiftwidth = 2
		end,
		group = group,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		pattern = { "*.md", "*.txt", "*.tex" },
		callback = function()
			-- actual mapping
			-- I don't know why I need this.
			vim.opt.tabstop = 2
			vim.opt.shiftwidth = 2
			-- for conceal cool stuff
			vim.opt.conceallevel = 2
		end,
		group = group,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		pattern = { "*.txt", "*.tex" },
		command = "setlocal wrap",
		group = group,
	})

	group = vim.api.nvim_create_augroup("filetypeindent", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "sql", "python" },
		callback = function()
			vim.opt.tabstop = 4
			vim.opt.shiftwidth = 4
		end,
		group = group,
	})

	group = vim.api.nvim_create_augroup("colorcolumns", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "sql", "vimwiki", "markdown" },
		callback = function()
			vim.opt.colorcolumn = "120"
		end,
		group = group,
	})

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight on yank",
		callback = function()
			vim.highlight.on_yank({ higroup = "Visual", timeout = 100 })
		end,
	})
end

return M
