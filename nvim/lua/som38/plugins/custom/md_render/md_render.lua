local util = require("som38.plugins.custom.md_render.util")

local M = {}

local function get_img_table(filename, row, col)
	return {
		row,
		col,
		filename = filename,
	}
end

local function render_window(pref)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local buf, win = util.open_win()
	local col = vim.api.nvim_win_get_position(win)[2]
	local imgs = {}
	local offset = 1
	for _, line in ipairs(lines) do
		local line_or_blanks, filename = util.handle_line(line, pref)
		vim.api.nvim_buf_set_lines(buf, -2, -2, false, line_or_blanks)
		if filename ~= nil then
			table.insert(imgs, get_img_table(filename, offset, col + 7))
		end
		offset = offset + #line_or_blanks
	end
	return imgs, win
end

local function render_imgs(t)
	for _, v in ipairs(t) do
		util.render_image(v[1], v[2], v["filename"])
	end
end

function M.render(timeout, pref)
	local imgs, win = render_window(pref)
	vim.defer_fn(function()
		render_imgs(imgs)
	end, timeout)
	return win
end

return M
