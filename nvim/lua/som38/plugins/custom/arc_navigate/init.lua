local arc = require("som38.plugins.custom.arc_navigate.arc")

vim.keymap.set("n", "<leader>tt", function()
	vim.ui.open("https://st.yandex-team.ru/" .. vim.fn.expand("<cfile>"))
end, { desc = "Open a tracker ticket" })

vim.keymap.set("n", "<leader>o", arc.arcadia_map(), {
	desc = "Open file in arcadia",
})

vim.keymap.set("n", "<leader>O", arc.arcadia_map("line"), {
	desc = "Open file in arcadia",
})

vim.keymap.set("v", "<leader>o", arc.arcadia_map("range"), {
	desc = "Open file in arcadia",
})

vim.api.nvim_create_user_command("PR", function()
	vim.system({ "arc", "pr", "view" })
end, {
	desc = "Open a pr in arcadia",
})
