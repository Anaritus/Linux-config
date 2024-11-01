local dark = "catppuccin-mocha"
local dark_theme = require("lualine.themes.catppuccin-mocha")
local dark_palette = require("catppuccin.palettes").get_palette("mocha")

local light = "catppuccin-latte"
local light_theme = require("lualine.themes.catppuccin-latte")
local light_palette = require("catppuccin.palettes").get_palette("latte")

local function theme_dark()
	vim.cmd("colorscheme " .. dark)
	vim.cmd("Reactive enable " .. dark .. "-cursor")
	vim.cmd("Reactive enable " .. dark .. "-cursorline")
	vim.cmd("Reactive disable " .. light .. "-cursor")
	vim.cmd("Reactive disable " .. light .. "-cursorline")
	require("som38.plugins.lualine").personal_config(dark_theme, dark_palette)
end

local function theme_light()
	vim.cmd("colorscheme " .. light)
	vim.cmd("Reactive disable " .. dark .. "-cursor")
	vim.cmd("Reactive disable " .. dark .. "-cursorline")
	vim.cmd("Reactive enable " .. light .. "-cursor")
	vim.cmd("Reactive enable " .. light .. "-cursorline")
	require("som38.plugins.lualine").personal_config(light_theme, light_palette)
end

local function toggle_theme()
	if vim.g.colors_name == dark then
		theme_light()
	else
		theme_dark()
	end
end

vim.api.nvim_create_user_command(
	"ToggleColors",
	toggle_theme,
	{ desc = "Toggles colorscheme between mocha and latte respecting Reactive" }
)

vim.api.nvim_create_user_command("DarkColors", theme_dark, { desc = "Makes colorscheme mocha" })

vim.api.nvim_create_user_command("LightColors", theme_light, { desc = "Makes colorscheme latte" })
vim.keymap.set("n", "<leader>tc", toggle_theme)
