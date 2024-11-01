require("som38.core")
require("som38.dev")
require("som38.lazy")
require("som38.after")

-- work plugins
pcall(require, "som38.work")

-- My custom plugins
require("md_render")
require("theme_toggler")
vim.cmd("DarkColors")
