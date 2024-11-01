local renderer = require("som38.plugins.custom.md_render.md_render")

local opts = {
	delay = 100,
	root = "~/Notes/",
}

local win
local rendered = false

local function toggle_render_callback()
	if not rendered then
		win = renderer.render(opts["delay"], opts["root"])
		rendered = true
		return
	end
	vim.api.nvim_win_close(win, true)
	rendered = false
end

local group = vim.api.nvim_create_augroup("md_render", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.md" },
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "tr", "", {
			callback = toggle_render_callback,
		})
		vim.api.nvim_buf_create_user_command(0, "Render", toggle_render_callback, {})
	end,
	group = group,
})
