-- TODO: move the shorcut to snacks's dashboard

local printf = require("plugins.util.printf").printf

local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣦⣤⣄⣠⣤⣀⣤⣄⡀⠀⣰⣦⣄⣀⡀⠀⠀⣴⣦⣤⣠⣤⣄⣤⣤⣀⡀⠀⣰⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠻⣿⣿⣿⣿⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠃⠀⠀⠀⠈⢹⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠁⠀⠀⠀⠀⢹⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⢀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡟⠀⠀⠀⠀⢸⣿⡄⠀⠀⠀⠀⢸⣿⠀⠀⢠⣾⡗⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⢸⣿⠀⠀⢸⣿⡇⠀⠀⠀⠀⢸⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠇⠀⠀⠀⠀⢸⡿⠃⠀⠀⠀⠀⢸⡿⠀⠀⣸⣿⠇⠀⠀⠀⠀⣸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
]]

-- NOTE: dashboard can alter buffer no. line and signcolumn when openingg buffer from trouble-nvim.
-- this is the message when running "verbose :set nu? rnu? signcolumn?" in vim command. need to run nvim -V1 in terminal to see the full message.
-- nonumber
-- 	Last set from ~/.local/share/nvim/lazy/dashboard-nvim/lua/dashboard/init.lua line 82
-- norelativenumber
-- 	Last set from ~/.local/share/nvim/lazy/dashboard-nvim/lua/dashboard/init.lua line 82
--   signcolumn=no
-- 	Last set from ~/.local/share/nvim/lazy/dashboard-nvim/lua/dashboard/init.lua line 82

local my_notes_dir = "~/jho-notes"

-- local os_util = require("plugins.util.check-os")
-- local os_name = os_util.get_os_name()

-- if os_name == os_util.OSX then
--   obsidian_path = "~/My Drive/obsidian-vault"
-- end

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          --       header = [[
          --       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
          --       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
          --       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
          --       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
          --       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
          --       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
          -- ]],
          header = logo,
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "󱙓 ", key = "n", desc = "My Personal Notes (Change Global Dir)", action = function () require("plugins.util.find-files").change_dir_and_find_files(my_notes_dir) end },
            { icon = " ", key = "t", desc = "Personal Todo", action = function () require("plugins.util.find-files").open_a_file("personal-todo-moc.md", my_notes_dir) end },
            { icon = " ", key = "c", desc = "Config (Change Global Dir)", action = function () require("plugins.util.find-files").change_dir_and_find_files("~/.config/nvim/") end },
            -- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          },
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local wk = require("which-key")
      local mapping = {
        -- TODO: add snack's dashboard to which-key.
        -- { "<leader>D", "<cmd>Dashboard<cr>", icon = "󰨇 ", group = printf("Dashboard"), mode = "n" },
        { "<leader>D", "<cmd>lua Snacks.dashboard()<cr>", icon = "󰨇 ", group = printf("Dashboard"), mode = "n" },
      }
      wk.add(mapping)
    end,
  },
}

-- list of all other logos

-- local logo = [[
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⢀⣶⠁⢠⣶⠞⠀⣠⣴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣮⢀⣠⣷⣿⣶⣿⣿⣶⣾⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⣿⣿⣯⣿⢿⣿⣯⣿⣏⣏⣯⣯⣯⣯⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⣶⣾⣿⣫⣯⣟⢯⣫⣮⣿⣷⣾⣯⣯⣿⣯⣯⣿⣯⣯⣿⣷⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⢈⣤⣯⣻⣮⠿⠛⠋⠛⠛⣿⣿⣿⣏⣯⣯⣿⣯⣯⣯⣿⣷⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⡀⠀⠀⠀⠀⠀⠀⠉⣿⣿⣯⣿⣿⣿⣿⣯⣯⣿⠓⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣨⣿⣫⢏⢟⣻⣯⣏⣇⣿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣇⣫⣪⣮⣮⣯⣏⣯⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣫⣎⣇⣧⣮⣮⣯⣯⣿⡟⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣶⣶⣶⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣟⣮⣯⣧⣯⣯⣿⣯⣿⣿⠁⠀⣴⣧⠀⠀⠀⣠⠀⠀⣠⣔⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣯⣿⣯⣯⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣯⣯⣯⣯⣯⣯⣯⡿⠁⣿⣶⠀⣿⣿⡄⢀⣯⡏⢀⣶⣿⠋⠀⠀⠀⠀⠀⠀⠀⣿⣯⣿⣿⣿⣿⣿⣯⣿⣯⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣯⣯⣯⣿⣯⣯⣿⣿⡄⠀⣸⣿⣴⣿⣿⣿⣯⣿⣷⣿⣿⣿⣤⣶⠏⠀⠀⠀⠀⠀⠀⢻⣿⣯⣿⣿⣿⣿⣿⣿⣯⣯⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣯⣯⣯⣯⣏⣿⣿⣿⣾⣿⣿⣯⣿⣿⣯⣟⣿⣿⣿⣿⣿⣿⣥⡤⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣯⠙⣿⣿⣯⣿⣿⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣯⣿⣿⣯⣯⣯⣯⣿⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⡀⢀⢀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣟⠀⢻⣿⣿⣿⣿⣿⣦⣀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡄
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢿⣿⣯⣯⣿⣿⣿⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⡏⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣮⣤⣴⣤⣤⣶⣷⣶⣶⣶⣿⣿⣿⠁
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣯⣯⣿⣿⣿⣿⣿⣯⣿⣿⣿⣯⣧⣿⣿⣯⣯⣿⣯⣿⣿⣯⣯⣿⡟⠀⠀⠀⠀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠁⠀
-- ⠀⠀⠀⠀⢀⣄⣀⣤⣶⣾⣶⣿⣿⣯⣿⣿⣿⣿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣯⣯⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠏⠀⠀⠀⠀⠀
-- ⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉⠋⠋⠉⠉⠉⠉⠉⠻⢿⠻⢿⣯⠯⢯⠿⢿⢿⠶⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠛⣯⠉⠉⠛⠿⠉⠉⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀
--     ]]

--     local logo = [[
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢴⡷⠀⠀⠀⠀⠀⡠⢾⠀⠀⠀⢰⣶⣆⣀⠀⠀⠀⠀⡀⡆⠀⠀⠀⠀⣠⢆⠀⠀⠀⢀⣴⡄⠀⠀⣴⣾⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠫⣿⢡⠀⠀⠀⠀⢺⣿⡆⠀⠀⠈⠋⠾⣿⣶⠀⠀⠀⠩⣫⡄⠀⠀⠀⡿⣿⠀⠀⠀⢸⣾⡇⠀⠀⠈⠙⠹⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⡆⠀⠀⠀⠘⣿⡇⠀⠀⠀⠀⠀⢹⣿⠀⠀⠀⠀⠼⣟⠀⠀⠀⣸⡊⠀⠀⠀⠘⣿⡇⠀⠀⠀⠀⠀⠈⣳⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣭⠀⠀⠀⠀⣿⠇⠀⠀⣶⡆⠀⢸⣿⠀⠀⠀⠀⠘⣿⣆⢀⣤⠏⠀⠀⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⢰⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣥⠀⠀⣠⡕⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠛⣟⠛⠀⠀⠀⠀⠀⠀⢼⠃⠀⠀⠀⠀⠀⠰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢫⡤⡮⠚⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠈⣗⣇⠀⠀⢀⡠⡰⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣲⣲⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠟⠀⠀⠀⠀⠀⠀⠹⣿⣿⡻⠻⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠁⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠛⠛⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠀⠘⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
--     ]]

-- local logo = [[
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣶⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⠿⠿⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⡀⠀⠀⠀⠀⠀⣠⣾⣿⠀⠀⣠⣿⣿⣷⣄⡀⠀⠀⠀⠀⣠⣾⣷⡀⠀⠀⠀⢀⣾⣿⠀⠀⠀⠀⣠⣾⡇⠀⠀⣰⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣷⠀⠀⠀⠀⢾⣿⣿⣿⡄⠀⠻⢿⣿⣿⣿⣿⣦⡀⠀⠐⣿⣿⣿⣇⠀⠀⠀⣿⣿⣿⡇⠀⠀⢴⣿⣿⣿⠀⠘⠻⢿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣧⠀⠀⠀⠘⣿⣿⣿⡇⠀⠀⠀⠉⠻⣿⣿⣿⡇⠀⠀⠸⣿⣿⣿⡄⠀⠀⢸⣿⣿⡇⠀⠀⠘⣿⣿⣿⠀⠀⠀⠀⠈⠻⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⡆⠀⠀⠀⣿⣿⣿⡇⠀⣀⣀⣀⠀⢹⣿⣿⡇⠀⠀⠀⢻⣿⣿⣧⠀⠀⣼⣿⡿⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⡀⠀⠀⣸⣿⣿⠇⠀⣿⣿⣿⠀⢸⣿⣿⡇⠀⠀⠀⠘⣿⣿⣿⣶⣾⣿⠟⠀⠀⠀⠀⠀⣿⣿⡏⠀⠀⠀⠀⠀⢀⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣧⠀⢀⣿⣿⡟⠀⠀⠈⠉⠉⠀⢸⣿⣿⡇⠀⠀⠀⠀⢻⣿⣿⣿⠟⠁⠀⠀⠀⠀⢀⣼⣿⡿⠀⠀⠀⠀⠀⢠⣾⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣾⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠈⣿⣿⣿⡆⠀⠀⣀⣤⣶⣿⣿⠟⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣶⣾⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠏⠀⠀⠀⠀⠀⠀⠀⠙⠿⠿⠿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠉⠁⣶⣶⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣶⣶⡆⢰⣶⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠛⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⠿⠃⠸⠿⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ]]

-- old plugin

-- {
--   "nvimdev/dashboard-nvim",
--   enabled = false,
--   opts = function(_, opts)
--     -- NOTE: create the braille at https://asciiart.club/
--     -- https://superemotes.com/img2ascii#google_vignette -- just copy the text.

--     logo = string.rep("\n", 8) .. logo .. "\n\n"
--     opts.config.header = vim.split(logo, "\n")

--     local obsidian_path = "~/obsidian-syncthing"

--     local os_util = require("plugins.util.check-os")
--     local os_name = os_util.get_os_name()

--     if os_name == os_util.OSX then
--       obsidian_path = "~/My Drive/obsidian-vault"
--     end

--     -- add new dashboard item obsidian_todos.
--     local obsidian_todos = {
--       action = string.format([[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("%s/todos/")]], obsidian_path),
--       desc = printf("Obsidian Todos"),
--       icon = "  ",
--       key = "t",
--     }

--     obsidian_todos.desc = obsidian_todos.desc .. string.rep(" ", 43 - #obsidian_todos.desc)
--     obsidian_todos.key_format = "  %s"

--     table.insert(opts.config.center, 2, obsidian_todos)

--     -- update_dashboard_shortcut(opts, "c", [[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("~/.config/nvim/")]], " Config")

--     -- -- remove some defaults dashboard items.
--     -- -- remove_dashboard_item is moved to util.lua
--     -- remove_dashboard_item(opts, "n") -- remove create new file.
--     -- remove_dashboard_item(opts, "x") -- remove lazyvim xtra.
--     -- remove_dashboard_item(opts, "l") -- remove lazy.
--     -- remove_dashboard_item(opts, "p") -- remove projects.
--     -- remove_dashboard_item(opts, "r") -- remove recent files.

--     -- NOTE: not used dashboard items.
--     -- -- add new dashboard item obsidian_inbox.
--     -- local obsidian_inbox = {
--     --   action = string.format([[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("%s/inbox/")]], obsidian_path),
--     --   desc = printf("Obsidian Inbox"),
--     --   icon = "󱉳  ",
--     --   key = "i",
--     -- }
--     -- obsidian_inbox.desc = obsidian_inbox.desc .. string.rep(" ", 43 - #obsidian_inbox.desc)
--     -- obsidian_inbox.key_format = "  %s"
--     -- table.insert(opts.config.center, 3, obsidian_inbox)

--     -- local lazyvim_config = {
--     --   action = [[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("~/.local/share/nvim/lazy/LazyVim/")]],
--     --   desc = printf("Lazyvim Config"),
--     --   icon = "  ",
--     --   key = "L",
--     -- }
--     -- lazyvim_config.desc = lazyvim_config.desc .. string.rep(" ", 43 - #lazyvim_config.desc)
--     -- lazyvim_config.key_format = "  %s"
--     -- table.insert(opts.config.center, 11, lazyvim_config)
--   end,
-- },
