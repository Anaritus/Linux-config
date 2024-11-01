local M = {}

---Whether or not the path is in arc repo
---@param path string
---@return boolean
function M.is_in_arc(path)
	return vim.system({ "arc", "root" }, { cwd = path }):wait().code == 0
end

---Get arc root
---@param cwd string? cwd of command
---@return string? path the path to arc root
---@return boolean ok successfullness
function M.get_arc_root(cwd)
	local result
	if not cwd then
		result = vim.system({ "arc", "root" }):wait()
	else
		result = vim.system({ "arc", "root" }, { cwd = cwd }):wait()
	end
	return vim.trim(result.stdout), result.code == 0
end

---Get URL for a file in arcadia
---@param path any
---@return string?
function M.get_url_in_arcadia(path)
	path = path or vim.fn.expand("%")
	if path:sub(1, 1) ~= "/" then
		vim.print(path)
		path = vim.fn.getcwd() .. "/" .. path
	end
	local dir = path:gsub("(.*)/.*", "%1")
	vim.print(dir)
	local root, ok = M.get_arc_root(dir)
	if not ok then
		vim.print("File is not in arc repo")
		return nil
	end
	local arc_path = path:gsub("^" .. root, "")
	return "https://a.yandex-team.ru/arcadia" .. arc_path
end

---Open file in arcadia
---@param line 'range'|'line'?
---@param path string?
function M.open_in_arcadia(path, line)
	local url = M.get_url_in_arcadia(path)
	if not url then
		return
	end
	if line then
		if line == "line" then
			url = url .. "#L" .. vim.api.nvim_win_get_cursor(0)[1]
		elseif line == "range" then
			vim.print("normal")
			vim.cmd('execute "normal! \\<ESC>"')
			local start = vim.api.nvim_buf_get_mark(0, "<")[1]
			local endl = vim.api.nvim_buf_get_mark(0, ">")[1]
			if start == endl then
				url = url .. "#L" .. start
			else
				url = url .. "#L" .. start .. "-" .. endl
			end
		end
	end
	vim.ui.open(url)
end

---for mapping
---@param mode 'range'|'line'?
function M.arcadia_map(mode)
	return function()
		M.open_in_arcadia(nil, mode)
	end
end

return M
