-- not using chezmoi for dotfiles anymore

return {}

-- -- local printf = require("plugins.util.printf").printf
-- -- local chezmoi_dir = os.getenv("HOME") .. "/.local/share/chezmoi/*"

-- local function watch_file_changes()
--   local path = vim.fn.stdpath("config") .. "/lua/vscode-snippets"

--   -- Set up a file watcher using fs_event
--   local watcher = vim.loop.new_fs_event()

--   -- Define the callback when a file change is detected
--   local function on_change(_, filename, events)
--     -- Ensure events is a table and check for "change" event
--     if vim.tbl_contains(events, "change") then
--       -- When file changes, trigger chezmoi update
--       vim.cmd("!chezmoi add ~/.config/nvim/lua/vscode-snippets/")
--       print("vscode-snippets updated and added to chezmoi.")
--     end
--   end

--   -- Start watching the directory for changes
--   watcher:start(path, { "change" }, on_change)

--   -- Optional: to stop the watcher, use `watcher:stop()`
-- end

-- local pick_chezmoi = function()
--   if LazyVim.pick.picker.name == "telescope" then
--     require("telescope").extensions.chezmoi.find_files()
--   elseif LazyVim.pick.picker.name == "fzf" then
--     local fzf_lua = require("fzf-lua")
--     local results = require("chezmoi.commands").list()
--     local chezmoi = require("chezmoi.commands")

--     local opts = {
--       fzf_opts = {},
--       fzf_colors = true,
--       actions = {
--         ["default"] = function(selected)
--           chezmoi.edit({
--             targets = { "~/" .. selected[1] },
--             args = { "--watch" },
--           })
--         end,
--       },
--     }
--     fzf_lua.fzf_exec(results, opts)
--   elseif LazyVim.pick.picker.name == "snacks" then
--     local results = require("chezmoi.commands").list({
--       args = {
--         "--path-style",
--         "absolute",
--         "--include",
--         "files",
--         "--exclude",
--         "externals",
--       },
--     })
--     local items = {}

--     for _, czFile in ipairs(results) do
--       table.insert(items, {
--         text = czFile,
--         file = czFile,
--       })
--     end

--     ---@type snacks.picker.Config
--     local opts = {
--       items = items,
--       confirm = function(picker, item)
--         picker:close()
--         require("chezmoi.commands").edit({
--           targets = { item.text },
--           args = { "--watch" },
--         })
--       end,
--     }
--     Snacks.picker.pick(opts)
--   end
-- end

-- -- this plugins makes editing chezmoi dotfiles faster and easier

-- -- TODO: it is kinda slow when opening file, saving and auto chezmoi apply. turn off auto chezmoi apply?

-- return {
--   {
--     -- highlighting for chezmoi files template files
--     "alker0/chezmoi.vim",
--     event = "VeryLazy",
--     init = function()
--       vim.g["chezmoi#use_tmp_buffer"] = 1
--       vim.g["chezmoi#source_dir_path"] = os.getenv("HOME") .. "/.local/share/chezmoi"
--     end,
--   },

--   {
--     "xvzc/chezmoi.nvim",
--     event = "VeryLazy",
--     init = function()
--       -- Start watching the directory in the background
--       watch_file_changes()

--       -- automatically apply changes on files under chezmoi source path
--       -- this apply command is for that buffer only, not the entire chezmoi source path
--       vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--         pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
--         callback = function(ev)
--           local bufnr = ev.buf
--           local edit_watch = function()
--             require("chezmoi.commands.__edit").watch(bufnr)
--           end
--           vim.schedule(edit_watch)
--         end,
--       })

--       vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--         pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },

--         callback = function()
--           vim.print("to apply changes, run chezmoi apply", "info", { title = "chezmoi.nvim" })
--         end,
--       })

--       -- Create an autocmd that listens for specific commands
--       vim.api.nvim_create_autocmd("CmdlineLeave", {
--         pattern = vim.fn.stdpath("config") .. "/lua/vscode-snippets/*",
--         -- pattern = ":*",
--         callback = function()
--           print("kekekeke")
--           local cmd = vim.fn.getcmdline()

--           print(cmd .. "kekeke akkaka")

--           -- Check if the command matches one of the scissors commands
--           if cmd == "ScissorsAddNewSnippet" then
--             print("ScissorsAddNewSnippet command executed")
--           elseif cmd == "ScissorsEditSnippet" then
--             print("ScissorsEditSnippet command executed")
--           end
--         end,
--       })
--     end,

--     dependencies = { "nvim-lua/plenary.nvim" },

--     config = function()
--       require("chezmoi").setup({
--         edit = {
--           watch = false,
--           force = false,
--         },
--         notification = {
--           on_open = true,
--           on_apply = true,
--           on_watch = true,
--         },
--         telescope = {
--           select = { "<CR>" },
--         },
--       })
--     end,

--     keys = {
--       {
--         "<leader>sz",
--         pick_chezmoi,
--         desc = "Chezmoi",
--       },
--     },
--   },

--   -- Filetype icons
--   {
--     "echasnovski/mini.icons",
--     opts = {
--       file = {
--         [".chezmoiignore"] = { glyph = "", hl = "MiniIconsGrey" },
--         [".chezmoiremove"] = { glyph = "", hl = "MiniIconsGrey" },
--         [".chezmoiroot"] = { glyph = "", hl = "MiniIconsGrey" },
--         [".chezmoiversion"] = { glyph = "", hl = "MiniIconsGrey" },
--         ["bash.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
--         ["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
--         ["ps1.tmpl"] = { glyph = "󰨊", hl = "MiniIconsGrey" },
--         ["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
--         ["toml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
--         ["yaml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
--         ["zsh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
--       },
--     },
--   },
-- }
