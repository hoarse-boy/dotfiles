local my_notes_dir = "~/jho-notes"
local printf = require("plugins.util.printf").printf

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "yaml", "yml", "toml" },
  callback = function()
    vim.b.snacks_indent = false
  end,
})

-- local is_bigfile = require("plugins.util.check-for-bigfile").is_bigfile

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

-- local my_notes_dir = "~/jho-notes" -- DEL: . DELETE LINES LATER

-- local os_util = require("plugins.util.check-os")
-- local os_name = os_util.get_os_name()

-- if os_name == os_util.OSX then
--   obsidian_path = "~/My Drive/obsidian-vault"
-- end

-- all snacks.nvim configs goes here
return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        -- enabled = enabledAnimation,
        -- enabled = not is_bigfile(),

        animate = {
          duration = { step = 6, total = 100 },
          -- duration = { step = 15, total = 250 }, -- default. higher total value will makes `g` or `G` to be slower even with lower step value.
          easing = "linear",
        },
        -- what buffers to animate
        -- filter = function(buf) -- NOTE: this makes the bullet.vim to have errors as it tries to delete mapping that doesn't exist
        --   return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
        -- end,
      },
    },
  },

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
            { icon = " ", key = "p", desc = "Personal Todo", action = function () require("plugins.util.find-files").open_a_file("personal-todo-moc.md", my_notes_dir) end },
            { icon = " ", key = "n", desc = "My Quick Note", action = function () require("plugins.util.find-files").open_a_file("quick-note.md", my_notes_dir) end },
            -- { icon = "󱙓 ", key = "n", desc = "My Notes (Change Global Dir)", action = function () require("plugins.util.find-files").change_dir_and_find_files(my_notes_dir) end },
            -- { icon = " ", key = "c", desc = "Config (Change Global Dir)", action = function () require("plugins.util.find-files").change_dir_and_find_files("~/.local/share/chezmoi/dot_config/nvim") end },
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

  {
    "folke/snacks.nvim",
    -- event = "VeryLazy",
    event = "VimEnter", -- load only when UI is ready
    opts = {
      -- scratch buffer
      scratch = {
        name = "quick-note",
        file = my_notes_dir .. "/quick-note.md", -- use this to avoid strange name generated
        ft = "markdown",
        icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
        -- root = my_notes_dir, -- will use 'file' property instead
        -- root = vim.fn.stdpath("data") .. "/scratch", -- default
        autowrite = true, -- automatically write when the buffer is hidden
        filekey = {
          cwd = false, -- use current working directory
          branch = false, -- use current branch name
          count = false, -- use vim.v.count1
        },
        win = { style = "scratch" },
      },

      -- picker and explorer has the same config. hidden is true will make both explorer and picker hidden files to show up.
      -- any config here will overwrite to all pickers. such as args, be careful.
      picker = {
        -- lsp picker still shows excluded files. maybe because it is needed as there are lsp references to them.
        exclude = {
          ".git",
          "node_modules",
          "vendor",
          "*.pb.go",
        },

        hidden = true, -- true to shows .files or hidden files
        ignored = true, -- true to shows ignored files. tools like `fd` respects .gitignore and this will make them show up.
        -- args = {} -- NOTE: don't add any args here as this is will overwrite to all sources / pickers

        matcher = {
          frecency = true,
        },

        explorer = {
          -- enable = false,
        },

        -- sources contains all of the pickers table. such as files, grep, todo_comments which are all default sources or pickers.
        -- add new table to create custom pickers.
        -- https://github.com/folke/snacks.nvim/issues/1023
        sources = {
          -- overwrite the default 'files' picker to exclude some files and show hidden files
          files = {
            -- hidden and ignored must be assigned inside sources.files picker as it will not work when enabling in picker only
            hidden = true, -- true to shows .files or hidden files
            ignored = true, -- true to shows ignored files. tools like `fd` respects .gitignore and this will make them show up.
            -- cmd = "fd",
          },

          -- example of creating new custom picker
          -- custom_picker = {}
        },

        debug = {
          scores = false, -- `true` to show scores in the list. debugging only
        },
      },

      -- snacks notifier
      -- TODO: add snack-notifier config her

      -- snacks image config at markdown.lua
      -- snacks animate config at animation.lua

      -- bigfile
      bigfile = {
        enabled = true, -- enable big file detection
        notify = true, -- show notification when big file detected
        size = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 10000, -- average line length (useful for minified files)
        -- Enable or disable features when big file detected
        ---@param ctx {buf: number, ft:string}
        setup = function(ctx)
          if vim.fn.exists(":NoMatchParen") ~= 0 then
            vim.cmd([[NoMatchParen]])
          end
          Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
          vim.b.minianimate_disable = true

          vim.schedule(function() -- FIX: . Check and test this. remove comments later
            if vim.api.nvim_buf_is_valid(ctx.buf) then
              vim.treesitter.stop(ctx.buf) -- stops Treesitter for this buffer
            end
          end)

          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ctx.buf) then
              vim.bo[ctx.buf].syntax = ctx.ft
            end
          end)
        end,
      },

      -- indent
      indent = {
        -- enabled = false,
        -- enabled = not is_bigfile(),

        ---@class snacks.indent.Config
        indent = {
          -- enabled = false, -- enable indent guides
          -- char = "▎",
          char = "│",
          -- char = char_symbol,
          blank = " ",
          -- blank = "∙",
          only_scope = false, -- only show indent guides of the scope
          only_current = false, -- only show indent guides in the current window
          -- hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
          -- can be a list of hl groups to cycle through
          hl = {
            "Comment",
            -- "SnacksIndent2",
            -- "SnacksIndent3",
            -- "SnacksIndent4",
            -- "SnacksIndent5",
            -- "SnacksIndent6",
            -- "SnacksIndent7",
            -- "SnacksIndent8",
          },
        },
        ---@class snacks.indent.Scope.Config: snacks.scope.Config
        scope = {
          enabled = true, -- enable highlighting the current scope
          -- animate scopes. Enabled by default for Neovim >= 0.10
          -- Works on older versions but has to trigger redraws during animation.
          ---@type snacks.animate.Config|{enabled?: boolean}
          animate = {
            enabled = vim.fn.has("nvim-0.10") == 1,
            easing = "linear",
            duration = {
              step = 20, -- ms per step
              total = 500, -- maximum duration
            },
          },
          char = "│",
          -- char = char_symbol,
          -- underline = true, -- underline the start of the scope
          underline = false, -- underline the start of the scope
          -- only_current = true, -- only show scope in the current window
          only_current = false, -- only show scope in the current window
          hl = "Function", ---@type string|string[] hl group for scopes
          -- hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
        },
        chunk = {
          -- when enabled, scopes will be rendered as chunks, except for the
          -- top-level scope which will be rendered as a scope.
          enabled = true,
          -- enabled = false,
          -- only show chunk scopes in the current window
          -- only_current = true,
          only_current = false,
          hl = "Function", ---@type string|string[] hl group for chunk scopes
          -- hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
          char = {
            -- corner_top = "┌",
            -- corner_bottom = "└",
            corner_top = "╭",
            -- corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            -- vertical = char_symbol,
            vertical = "│",
            arrow = ">",
          },
        },
        -- filter for buffers to enable indent guides
        -- filter = function(buf)
        --   return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        -- end,
        priority = 200,
      },

      terminal = {},
    },

    keys = {
      -- stylua: ignore start
      { "<leader>.",  function() Snacks.scratch() end, desc = printf("Toggle 'quick-note' Buffer") },

      -- overwriting to make it consistent with other keybinding where the capital letter is for workspace or all files. remove this if lazyvim's default has been changed
      { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = printf"Buffer Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = printf"Diagnostics" },
      -- { "<leader>T", function() Snacks.terminal({ "lazygit"}) end, desc = printf"Lazygit Terminal" },
      { "<leader>H", function() Snacks.terminal("slumber -f ~/work/sync-work/slumber-http/slumber.yml") end, desc = printf"Http Client (slumber)" },
      -- stylua: ignore end
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local wk = require("which-key")
      local mapping = {
        { "<leader>uH", "<cmd>lua Snacks.notifier.show_history()<cr>", desc = printf("Show Notifier History"), mode = "n" },
      }
      wk.add(mapping)
    end,
  },
}
