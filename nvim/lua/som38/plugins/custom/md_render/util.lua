local M = {}

function M.render_image(row, col, filename)
	local handle = io.popen("img2sixel '" .. filename .. "'")
	if not handle then
		return
	end
	local output = handle:read("a")
	local echoraw = function(str)
		vim.fn.chansend(vim.v.stderr, str)
	end
	echoraw("\27[s")
	echoraw(string.format("\27[%d;%dH", row, col))
	echoraw(output)
	echoraw("\27[u")
end

function M.open_win()
	local buf = vim.api.nvim_create_buf(false, true)
	local filetype = vim.api.nvim_get_option_value("filetype", {
		buf = 0,
	})
	vim.api.nvim_set_option_value("filetype", filetype, {
		buf = buf,
	})
	local win = vim.api.nvim_open_win(buf, false, {
		split = "right",
	})
	return buf, win
end

function M.handle_line(line, pref)
	if not line:find("^!%[.*]%([^(]+%)$") then
		return { line }
	end
	local t = {}
	local filename = line:match("%(.+%)"):sub(2, -2):gsub("%%20", " ")
	for _ = 1, M.get_image_height(filename) do
		table.insert(t, "")
	end
	return t, filename
end

function M.get_image_height(filename)
	local cmd = "identify -format '%h' '" .. filename .. "'"
	P(cmd)
	local handle = io.popen(cmd)
	if not handle then
		return 0
	end
	local output = handle:read("a")
	return output / 32
end

return M
