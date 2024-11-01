return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		transparent_bakground = true,
		term_colors = true,
		custom_highlights = function(colors)
			return {
				-- hi ObsidianHighlightText guibg=#a6e3a1 guifg=#313244
				ObsidianHighlightText = { bg = colors.green },
				Special = { fg = colors.blue },
				Statement = { fg = colors.lavender },
				NormalFloat = { fg = colors.text, bg = colors.base },
				NeoTreeNormal = { bg = colors.base },
				NeoTreeNormalNC = { bg = colors.base },
				iCursor = { fg = colors.green },
			}
		end,
		integrations = {
			fidget = true,
			harpoon = true,
			noice = true,
			neotree = true,
			mason = true,
		},
	},
}
