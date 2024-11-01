local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- add list of plugins to install
return require("lazy").setup({
	{ import = "som38.plugins" },
	{ import = "som38.plugins.lsp" },
	{ import = "som38.plugins.work" },
}, {
	install = {
		colorscheme = { "catppuccin" },
	},
	ui = {
		border = "rounded",
	},
	dev = {
		path = "~/.config/nvim/plugin",
	},
})
