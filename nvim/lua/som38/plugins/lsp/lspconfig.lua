return {
	"neovim/nvim-lspconfig", -- easily configure language servers
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- for autocompletion
		"jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
		"folke/neodev.nvim", -- better ls for plugin dev
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require("lspconfig")
		require("lspconfig.ui.windows").default_options.border = "rounded"
		require("neodev").setup()

		-- import cmp-nvim-lsp plugin safely
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- import typescript plugin safely
		local typescript = require("typescript")

		local keymap = vim.keymap -- for conciseness

		-- enable keybinds only for when lsp server available
		local on_attach = function(client, bufnr)
			-- keybind options
			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- set keybinds
			opts.desc = "got to declaration"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
			opts.desc = "see definition and make edits in window"
			keymap.set("n", "gD", function()
				vim.lsp.buf.declaration()
			end, opts)
			opts.desc = "go to implementation"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
			opts.desc = "go to type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)
			opts.desc = "see available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, opts)
			opts.desc = "smart rename"
			keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)
			opts.desc = "show  diagnostics for line"
			keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float()
			end, opts)
			opts.desc = "show  diagnostics for buffer"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
			opts.desc = "jump to previous diagnostic in buffer"
			keymap.set("n", "[d", function()
				vim.diagnostic.goto_prev()
			end, opts)
			opts.desc = "jump to next diagnostic in buffer"
			keymap.set("n", "]d", function()
				vim.diagnostic.goto_next()
			end, opts)
			opts.desc = "show documentation for what is under cursor"
			keymap.set("n", "K", function()
				vim.lsp.hover()
			end, opts)
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- border for diagnostics
		local _border = "rounded"

		vim.diagnostic.config({
			float = { border = _border },
		})

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["basedpyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				basedpyright = {
					analysis = {
						extraPaths = { "/Users/som38/arcadia" },
					},
				},
			},
			-- python = {
			-- 	venvPath = "/Users/som38/.config/python/",
			-- },
		})

		-- configure markdown server
		lspconfig["marksman"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure cmake server
		lspconfig["cmake"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure c++ server
		lspconfig["clangd"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
				"clangd",
				"cmake",
			},
		})

		-- configure typescript server with plugin
		typescript.setup({
			server = {
				capabilities = capabilities,
				on_attach = on_attach,
			},
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim", "P" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
	end,
}
