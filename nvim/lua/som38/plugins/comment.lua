return {
	"numToStr/Comment.nvim", -- commenting with gc
	event = { "BufReadPre", "BufNewFile" },
	keys = "gc",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = true,
}
