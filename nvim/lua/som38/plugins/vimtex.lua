return {
	-- Tex compiler
	"lervag/vimtex",
	-- event = "BufEnter *.tex",
	config = function()
		vim.g["vimtex_view_method"] = "sioyek"

		vim.g["vimtex_mappings_enabled"] = 1

		vim.g["vimtex_indent_enabled"] = 1

		vim.g["vimtex_syntax_enabled"] = 1

		vim.g["vimtex_compiler_latexmk"] = {
			aux_dir = "_aux_out/",
			out_dir = "",
			callback = 1,
			executable = "latexmk",
			hooks = {},
		}
	end,
}
