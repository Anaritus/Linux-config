local function map(mode, lhs, rhs, opts)
	-- default options
	local options = { noremap = true }

	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function nextSelect(forward)
	local direction = forward and "'W'" or "'bW'"
	return ":call search('select\\|SELECT'," .. direction .. ")<cr>"
end

local function nextVariable(forward)
	local direction = forward and "'W'" or "'bW'"
	return ":call search('^\\$\\w\\+\\|^define subquery\\|^DEFINE SUBQUERY'," .. direction .. ")<cr>"
end

map("n", "]s", nextSelect(true))
map("n", "[s", nextSelect(false))
map("n", "]$", nextVariable(true))
map("n", "[$", nextVariable(false))
