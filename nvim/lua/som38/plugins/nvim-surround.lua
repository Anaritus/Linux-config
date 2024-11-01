return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		local config = require("nvim-surround.config")
		require("nvim-surround").setup({
			surrounds = {
				["m"] = {
					add = { "$ ", " $" },
				},
				["$"] = {
					add = { "$ ", " $" },
				},
				["i"] = {
					add = { "\\textit{", "}" },
				},
				["b"] = {
					add = { "\\textbf{", "}" },
				},
				["a"] = {
					add = { "\\langle", "\\rangle" },
				},
				["g"] = {
					add = function()
						local result = config.get_input("Enter the text outline name: ")
						if result == "i" then
							return { { "\\textit{" }, { "}" } }
						end
						if result == "b" then
							return { { "\\textbf{" }, { "}" } }
						end
						if result then
							return { { "\\" .. result .. "{" }, { "}" } }
						end
					end,
				},
				["G"] = {
					add = function()
						local result = config.get_input("Enter the text function name: ")
						if result then
							return {
								{
									"\\begin{" .. result .. "} ",
								},
								{
									" \\end{" .. result .. "}",
								},
							}
						end
					end,
				},
				["B"] = {
					add = { "\\{", "\\}" },
				},
			},
		})
	end,
}
