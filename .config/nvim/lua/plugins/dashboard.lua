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

-- modify existing dashboard shortcut in config.center. the one showing when launching nvim.
local function update_dashboard_shortcut(opts, current_keymap, new_action, new_desc)
  for _, item in ipairs(opts.config.center) do
    if item.key == current_keymap then
      item.action = new_action
      item.desc = new_desc
    end
  end
end

local function remove_dashboard_item(opts, key_to_remove)
  for index, item in ipairs(opts.config.center) do
    if item.key == key_to_remove then
      table.remove(opts.config.center, index)
      break
    end
  end
end

-- NOTE: dashboard can alter buffer no. line and signcolumn when openingg buffer from trouble-nvim.
-- this is the message when running "verbose :set nu? rnu? signcolumn?" in vim command. need to run nvim -V1 in terminal to see the full message.
-- nonumber
-- 	Last set from ~/.local/share/nvim/lazy/dashboard-nvim/lua/dashboard/init.lua line 82
-- norelativenumber
-- 	Last set from ~/.local/share/nvim/lazy/dashboard-nvim/lua/dashboard/init.lua line 82
--   signcolumn=no
-- 	Last set from ~/.local/share/nvim/lazy/dashboard-nvim/lua/dashboard/init.lua line 82

local obsidian_path = "~/jho-notes"

local os_util = require("plugins.util.check-os")
local os_name = os_util.get_os_name()

if os_name == os_util.OSX then
  obsidian_path = "~/My Drive/obsidian-vault"
end

-- add new dashboard item obsidian_todos.
local daily_works = {
  action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath(vim.env.HOME)})",
  -- action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('~/jho-notes')})",
  -- action = string.format([[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("%s/daily/")]], obsidian_path),
  desc = printf("Daily Work Notes"),
  icon = " ",
  key = "t",
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
          ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
          ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
          ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
          ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
          ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
   ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            daily_works, -- FIX: buggy.
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },

  {
    "nvimdev/dashboard-nvim",
    enabled = false,
    opts = function(_, opts)
      -- NOTE: create the braille at https://asciiart.club/
      -- https://superemotes.com/img2ascii#google_vignette -- just copy the text.

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")

      local obsidian_path = "~/obsidian-syncthing"

      local os_util = require("plugins.util.check-os")
      local os_name = os_util.get_os_name()

      if os_name == os_util.OSX then
        obsidian_path = "~/My Drive/obsidian-vault"
      end

      -- add new dashboard item obsidian_todos.
      local obsidian_todos = {
        action = string.format([[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("%s/todos/")]], obsidian_path),
        desc = printf("Obsidian Todos"),
        icon = "  ",
        key = "t",
      }

      obsidian_todos.desc = obsidian_todos.desc .. string.rep(" ", 43 - #obsidian_todos.desc)
      obsidian_todos.key_format = "  %s"

      table.insert(opts.config.center, 2, obsidian_todos)

      update_dashboard_shortcut(opts, "c", [[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("~/.config/nvim/")]], " Config")

      -- remove some defaults dashboard items.
      remove_dashboard_item(opts, "n") -- remove create new file.
      remove_dashboard_item(opts, "x") -- remove lazyvim xtra.
      remove_dashboard_item(opts, "l") -- remove lazy.
      remove_dashboard_item(opts, "p") -- remove projects.
      remove_dashboard_item(opts, "r") -- remove recent files.

      -- NOTE: not used dashboard items.
      -- -- add new dashboard item obsidian_inbox.
      -- local obsidian_inbox = {
      --   action = string.format([[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("%s/inbox/")]], obsidian_path),
      --   desc = printf("Obsidian Inbox"),
      --   icon = "󱉳  ",
      --   key = "i",
      -- }
      -- obsidian_inbox.desc = obsidian_inbox.desc .. string.rep(" ", 43 - #obsidian_inbox.desc)
      -- obsidian_inbox.key_format = "  %s"
      -- table.insert(opts.config.center, 3, obsidian_inbox)

      -- local lazyvim_config = {
      --   action = [[lua require("plugins.util.teles-find").ChangeDirAndFindFiles("~/.local/share/nvim/lazy/LazyVim/")]],
      --   desc = printf("Lazyvim Config"),
      --   icon = "  ",
      --   key = "L",
      -- }
      -- lazyvim_config.desc = lazyvim_config.desc .. string.rep(" ", 43 - #lazyvim_config.desc)
      -- lazyvim_config.key_format = "  %s"
      -- table.insert(opts.config.center, 11, lazyvim_config)
    end,
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
