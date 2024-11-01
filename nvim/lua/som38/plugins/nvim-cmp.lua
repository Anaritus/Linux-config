return {
	"hrsh7th/nvim-cmp", -- completion plugin
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path", -- source for file system paths
		"onsails/lspkind.nvim", -- vs-code like icons for autocompletion
		-- snippets
		"hrsh7th/cmp-nvim-lua", -- lua nvim api
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
	},
	config = function()
		-- import nvim-cmp plugin safely
		local cmp = require("cmp")

		-- import luasnip plugin safely
		local luasnip = require("luasnip")

		-- import lspkind plugin safely
		local lspkind = require("lspkind")

		-- load vs-code like snippets from plugins (e.g. friendly-snippets)
		require("luasnip/loaders/from_vscode").lazy_load()

		vim.opt.completeopt = "menu,menuone,noselect"

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-q>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lua" },
				{ name = "nvim_lsp" }, -- lsp
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
				{ name = "vim-dadbod-completion" },
			}),
			-- configure lspkind for vs-code like icons
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		})
	end,
}
