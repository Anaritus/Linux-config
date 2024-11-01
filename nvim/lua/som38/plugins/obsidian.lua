return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	keys = {
		"<leader>w",
		"<leader>fn",
		"<leader>fm",
		"<leader>ft",
		"<leader>fw",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/Notes",
				overrides = {
					notes_subdir = "inbox",
				},
			},
			{
				name = "pets",
				path = "~/Notes",
				overrides = {
					notes_subdir = "pet_projects",
				},
			},
			{
				name = "straight",
				path = "~/Notes",
				overrides = {
					notes_subdir = "",
				},
			},
		},
		daily_notes = {
			folder = "diary",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			template = "daily-template.md",
		},
		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
		},

		log_level = vim.log.levels.INFO,
		new_notes_location = "notes_subdir",

		completion = {
			nvim_cmp = true,
		},
		-- Optional, customize how note IDs are generated given an optional title.
		---@param title string|?
		---@return string
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local name = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				name = title:gsub(" ", "-"):gsub("[^A-Za-z0-9а-яА-Я-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					name = name .. string.char(math.random(65, 90))
				end
			end
			return name
		end,

		-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
		-- URL it will be ignored but you can customize this behavior here.
		---@param url string
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			vim.fn.jobstart({ "open", url }) -- Mac OS
			-- vim.fn.jobstart({"xdg-open", url})  -- linux
		end,

		-- Optional, customize how note file names are generated given the ID, target directory, and title.
		---@param spec { id: string, dir: obsidian.Path, title: string|? }
		---@return string|obsidian.Path The full path to the new note.
		note_path_func = function(spec)
			-- This is equivalent to the default behavior.
			local path = spec.dir / tostring(spec.id)
			return path:with_suffix(".md")
		end,

		preferred_link_style = "markdown",
		callbacks = {
			post_setup = function(client)
				local keymap = vim.keymap
				keymap.set("n", "<leader>ww", ":ObsidianToday<cr>")
				keymap.set("n", "<leader>wt", ":ObsidianTomorrow<cr>")
				keymap.set("n", "<leader>wy", ":ObsidianYesterday<cr>")
				keymap.set("n", "<leader>wm", ":ObsidianNew<cr>")
				keymap.set("n", "<leader>wn", ":ObsidianTemplate<cr>")
				keymap.set("n", "<leader>wb", ":ObsidianBacklinks<cr>")
				keymap.set("n", "<leader>fn", ":ObsidianQuickSwitch<cr>")
				keymap.set("n", "<leader>fm", ":ObsidianSearch<cr>")
				keymap.set("n", "<leader>ft", ":ObsidianTags<cr>")
				keymap.set("n", "<leader>fw", ":ObsidianWorkspace<cr>")
				keymap.set("n", "<leader>fl", ":ObsidianBacklinks<cr>")
				vim.cmd("hi ObsidianHighlightText guibg=#a6e3a1 guifg=#313244")
			end,

			enter_note = function(client)
				vim.api.nvim_buf_set_keymap(0, "v", "<cr>", ":ObsidianLinkNew<cr>", {
					noremap = true,
					silent = true,
				})
				vim.api.nvim_buf_set_keymap(0, "n", "<leader>wr", ":ObsidianRename<cr>", {
					noremap = true,
					silent = true,
				})
				local function link_search_dir(forward)
					local flags = forward and "'w'" or "'bw'"
					local search_string = "'\\[[^[]*\\]([^(]*)\\|https:\\/\\/\\S\\+', "
					return ":call search(" .. search_string .. flags .. ")<cr>"
				end
				vim.api.nvim_buf_set_keymap(0, "n", "<tab>", link_search_dir(true), {
					noremap = true,
					silent = true,
				})
				vim.api.nvim_buf_set_keymap(0, "n", "<s-tab>", link_search_dir(false), {
					noremap = true,
					silent = true,
				})

				local function increment_header()
					local line = vim.api.nvim_get_current_line()
					local added_prefix = ""
					if line:find("#+ ") == 1 then
						added_prefix = "#"
					else
						added_prefix = "# "
					end
					vim.api.nvim_set_current_line(added_prefix .. line)
				end

				local function decrement_header()
					local line = vim.api.nvim_get_current_line()
					local start_ind = 1
					if line:find("# ") == 1 then
						start_ind = 3
					elseif line:find("##") == 1 then
						start_ind = 2
					end
					vim.api.nvim_set_current_line(line:sub(start_ind))
				end

				local function handle_current_line()
					local cur_line = vim.api.nvim_get_current_line()
					local suf = cur_line:match("%s*")
					if cur_line:find("%s*- %[.%]") == 1 then
						return suf .. "- [ ] "
					elseif cur_line:find("%s*- ") == 1 then
						return suf .. "- "
					end
					return suf
				end

				local function insert_new_line(lhs)
					local delta = lhs == "o" and 0 or -1
					return function()
						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						local new_line = handle_current_line()
						vim.api.nvim_buf_set_lines(0, row + delta, row + delta, false, { new_line })
						vim.api.nvim_win_set_cursor(0, { row + delta + 1, col })
						vim.cmd("norm $")
						vim.cmd("startinsert!")
					end
				end

				local function handle_enter()
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					local current_line = vim.api.nvim_get_current_line()
					if #current_line == col then
						insert_new_line("o")()
					else
						local pref = current_line:sub(0, col)
						local suf = current_line:sub(col + 1)
						local indent = current_line:match(" *")
						vim.api.nvim_set_current_line(pref)
						vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. suf })
						vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
						vim.cmd("startinsert")
					end
				end

				local function toggle_checkbox()
					local cur_line = vim.api.nvim_get_current_line()
					local stuff = cur_line:match(" *- %[.%]")
					if stuff == nil then
						return
					end
					local pref = stuff:sub(1, -3)
					local status = "x"
					if stuff:sub(-2, -2) ~= " " then
						status = " "
					end
					vim.api.nvim_set_current_line(pref .. status .. cur_line:sub(stuff:len()))
				end

				vim.api.nvim_buf_set_keymap(0, "n", "+", "", {
					noremap = true,
					silent = true,
					callback = increment_header,
				})
				vim.api.nvim_buf_set_keymap(0, "n", "-", "", {
					noremap = true,
					silent = true,
					callback = decrement_header,
				})
				vim.api.nvim_buf_set_keymap(0, "n", "O", "", {
					noremap = true,
					silent = true,
					callback = insert_new_line("O"),
				})
				vim.api.nvim_buf_set_keymap(0, "n", "o", "", {
					noremap = true,
					silent = true,
					callback = insert_new_line("o"),
				})
				-- vim.api.nvim_buf_set_keymap(0, "i", "<cr>", "", {
				-- 	noremap = true,
				-- 	silent = true,
				-- 	callback = handle_enter,
				-- })
				vim.api.nvim_buf_set_keymap(0, "n", "<leader>ch", "", {
					noremap = true,
					silent = true,
					callback = toggle_checkbox,
				})
			end,
		},
	},
}
