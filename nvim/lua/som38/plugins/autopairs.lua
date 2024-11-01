return {
	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...
	event = "InsertEnter",
	config = function()
		-- import nvim-autopairs safely
		local npairs = require("nvim-autopairs")

		-- configure autopairs
		npairs.setup({
			check_ts = true, -- enable treesitter
			ts_config = {
				lua = { "string" }, -- don't add pairs in lua string treesitter nodes
				javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
				java = false, -- don't check treesitter on java
			},
		})

		-- import nvim-autopairs completion functionality safely
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		-- import nvim-cmp plugin safely (completions plugin)
		local cmp = require("cmp")

		-- make autopairs and completion work together
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		local text_filetypes = {
			"tex",
			"markdown",
			"vimwiki",
			"rmd",
			"rmarkdown",
		}

		npairs.add_rule(Rule("$", "", text_filetypes)
			:with_pair(cond.not_inside_quote())
			:replace_endpair(function(opts)
				local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
				if prev_2char == "$ " then
					return "<bs><bs><del><del>$$$"
				end
				return "  $"
			end)
			:set_end_pair_length(2))

		npairs.add_rule(Rule("  ", "", text_filetypes):replace_endpair(function(opts)
			if opts.col == 2 then
				return "<bs>. "
			end
			return "<bs><bs>. "
		end):set_end_pair_length(0))

		npairs.add_rule(Rule("=", "", { "-sh", "-tex" })
			:with_pair(cond.not_inside_quote())
			:with_pair(function(opts)
				local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
				if last_char:match("[%w%=%s]") then
					return true
				end
				return false
			end)
			:replace_endpair(function(opts)
				local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
				local next_char = opts.line:sub(opts.col, opts.col)
				next_char = next_char == " " and "" or " "
				if prev_2char:match("%w$") then
					return "<bs> =" .. next_char
				end
				if prev_2char:match("%=$") then
					return next_char
				end
				if prev_2char:match("=") then
					return "<bs><bs>=" .. next_char
				end
				return ""
			end)
			:set_end_pair_length(0)
			:with_move(cond.none())
			:with_del(cond.none()))

		npairs.add_rule(Rule("\\[", "\\]", {
			"tex",
		}))
		npairs.add_rule(Rule("\\{", "\\}", {
			"tex",
		}))
		npairs.add_rule(Rule("\\langle", "\\rangle", {
			"tex",
		}))

		local function tab_handler(pattern_suf)
			npairs.add_rule(Rule("^%s*" .. pattern_suf .. "$", "", text_filetypes)
				:use_regex(true, "<tab>")
				:replace_endpair(function()
					return '<esc>0"_C' .. pattern_suf:gsub("%%", "")
				end)
				:with_move(cond.none())
				:with_del(cond.none()))
		end

		tab_handler("%- ")
		tab_handler("%- %[ %] ")
		local function handle_pref(line, pref)
			if #line == #pref then
				return (line:match("^%s+") and "<c-u>" or "") .. "<c-u>"
			end
			return "<cr>" .. pref:match("- .*")
		end

		npairs.add_rule(Rule("^%s*%- .*", "", text_filetypes)
			:use_regex(true)
			:use_key("<cr>")
			:replace_endpair(function(opts)
				local pref = opts.line:match("^%s*%- ")
				local pref_task = opts.line:match("^%s*%- %[.%] ")
				if pref_task ~= nil then
					return handle_pref(opts.line, pref_task)
				end
				return handle_pref(opts.line, pref)
			end)
			:with_move(cond.none())
			:with_del(cond.none()))
	end,
}
