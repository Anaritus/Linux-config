-- managing & installing lsp servers, linters & formatters
return {
	"williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig
	dependencies = {
		"williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
		-- "jayp0521/mason-null-ls.nvim", -- bridges gap b/w mason & null-ls
		"zapling/mason-conform.nvim",
		"stevearc/conform.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	config = function()
		local mason = require("mason")

		local mason_lspconfig = require("mason-lspconfig")

		mason.setup({
			ui = {
				border = "rounded",
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"marksman",
				"lua_ls",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		-- -- import mason-null-ls plugin safely
		-- local mason_null_ls = require("mason-null-ls")
		--
		-- mason_null_ls.setup({
		-- 	-- list of formatters & linters for mason to install
		-- 	ensure_installed = {
		-- 		"prettier", -- ts/js formatter
		-- 		"stylua", -- lua formatter
		-- 		"eslint_d", -- ts/js linter
		-- 		"blue", -- python formatter and linter
		-- 		"mypy",
		-- 	},
		-- 	-- auto-install configured formatters & linters (with null-ls)
		-- 	automatic_installation = true,
		-- })

		local mason_conform = require("mason-conform")

		mason_conform.setup({})
	end,
}
