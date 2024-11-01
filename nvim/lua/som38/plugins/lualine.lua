-- statusline
local function personal_config(theme, palette)
	-- import lualine plugin safelyline
	local lualine = require("lualine")
	palette = palette or require("catppuccin.palettes").get_palette("mocha")
	theme = theme or require("lualine.themes.catppuccin-mocha")
	local modes = { "normal", "insert", "visual", "replace", "command" }
	local components = { "b", "c", "x", "y", "z" }
	for _, mode in ipairs(modes) do
		for _, component in ipairs(components) do
			if theme[mode][component] ~= nil then
				theme[mode][component].bg = "None"
			end
		end
	end
	vim.opt.showcmdloc = "statusline"

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand("%:p:h")
			local gitdir = vim.fn.finddir(".git", filepath .. ";")
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	local function show_macro_recording()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return "Recording @" .. recording_register
		end
	end

	vim.api.nvim_create_autocmd("RecordingEnter", {
		callback = function()
			lualine.refresh({
				place = { "statusline" },
			})
		end,
	})

	vim.api.nvim_create_autocmd("RecordingLeave", {
		callback = function()
			-- This is going to seem really weird!
			-- Instead of just calling refresh we need to wait a moment because of the nature of
			-- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
			-- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
			-- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
			-- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
			local timer = vim.loop.new_timer()
			timer:start(
				50,
				0,
				vim.schedule_wrap(function()
					lualine.refresh({
						place = { "statusline" },
					})
				end)
			)
		end,
	})
	-- Now don't forget to initialize lualine
	lualine.setup({
		options = {
			component_separators = "",
			section_separators = "",
			theme = theme,
			always_divide_middle = false,
		},
		sections = {
			lualine_a = {
				{ "mode" },
			},
			lualine_b = {
				{
					"macro-recording",
					fmt = show_macro_recording,
					color = { fg = palette.red },
				},
				{
					"filesize",
					cond = conditions.buffer_not_empty,
				},
				{
					"filename",
					cond = conditions.buffer_not_empty,
					symbols = {
						unnamed = "",
						newfile = "",
					},
				},
			},
			lualine_c = {
				{ "location" },
				{ "progress" },
				{
					function()
						return "%="
					end,
				},
				{ "diagnostics" },
			},
			lualine_x = {},
			lualine_y = {
				{
					"%S",
					color = { bg = palette.base },
				},
			},
			lualine_z = {
				{ "o:encoding" },
				{
					"swenv",
					icon = "",
					color = { fg = palette.crust, bg = palette.teal },
				},
				{ "branch" },
				{ "b:gitsigns_status" },
			},
		},
		inactive_sections = {},
		extensions = {
			"oil",
			"fugitive",
			"quickfix",
			"neo-tree",
		},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		personal_config()
	end,
	personal_config = personal_config,
}
