return {
	-- slime
	"jpalardy/vim-slime",
	keys = {
		{
			"<leader>s",
			"<Plug>SlimeMotionSend",
			mode = "n",
		},
		{ "<leader>s", "<Plug>SlimeRegionSend", mode = "x" },
		{ "<leader>ss", "<Plug>SlimeLineSend", mode = "n" },
	},
	config = function()
		vim.g.slime_target = "tmux"
		vim.g.slime_python_ipython = 1
		vim.g.slime_default_config = {
			socket_name = "default",
			target_pane = ":.1",
		}
		local keymap = vim.keymap

		keymap.set("n", "<leader>s", "<Plug>SlimeMotionSend")
		keymap.set("x", "<leader>s", "<Plug>SlimeRegionSend")
		keymap.set("n", "<leader>ss", "<Plug>SlimeLineSend")
	end,
}
