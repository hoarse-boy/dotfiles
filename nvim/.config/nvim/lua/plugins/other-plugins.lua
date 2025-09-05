-- put all other plugins that do not need any major code setup
local printf = require("plugins.util.printf").printf

local char_symbol = "▏"
-- local char_symbol = "▎"
-- local char_symbol = "▎"
-- local char_symbol = "▍"
-- local char_symbol = "┃"
-- local char_symbol = "│"

-- NOTE: best v2 with wezterm enable undercurl => https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
-- disable these plugins to use one plugin that can do both without mini.indentscope performance hit.

return {
  {
    "okuuva/auto-save.nvim",
    enabled = true,
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
        defer_save = {
          "InsertLeave",
          "TextChanged",
          { "User", pattern = "VisualLeave" },
          { "User", pattern = "FlashJumpEnd" },
          { "User", pattern = "SnacksInputLeave" },
          { "User", pattern = "SnacksPickerInputLeave" },
        },
        cancel_deferred_save = {
          "InsertEnter",
          { "User", pattern = "VisualEnter" },
          { "User", pattern = "FlashJumpStart" },
          { "User", pattern = "SnacksInputEnter" },
          { "User", pattern = "SnacksPickerInputEnter" },
        },
      },
      condition = function(buf)
        -- only save markdown files
        if vim.bo[buf].filetype ~= "markdown" then
          return false
        end

        -- avoid saving in insert mode
        if vim.fn.mode() == "i" then
          return false
        end

        -- skip if in an active snippet
        if require("luasnip").in_snippet() then
          return false
        end

        -- other filetypes to ignore
        local ignore_ft = { harpoon = true, mysql = true, hyprlang = true }
        if ignore_ft[vim.bo[buf].filetype] then
          return false
        end

        return true
      end,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 2000,
      debug = false,
    },
  },

  {
    "akinsho/bufferline.nvim",
    enabled = true, -- FIX: . disable for now as the transparency is broken in nvim 0.11
    -- enabled = function()
    --   return not is_bigfile()
    -- end,

    opts = function(_, opts)
      opts.options = {
        diagnostics = "nvim_lsp",
        indicator = {
          icon = "", -- this should be omitted if indicator style is not 'icon'
          -- style = "none",
          style = "underline", -- "icon" | "underline" | "none", -- NOTE: underline is broken in tmux. somehow it is working in tmux. tested on mac for now.
        },


        -- highlights = { -- FIX: . not working. broken in nvim 0.11?
        --   fill = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   background = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   tab = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   tab_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   tab_separator = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   tab_separator_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     underline = "NONE",
        --   },
        --   tab_close = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   close_button = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   close_button_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   close_button_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   buffer_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   buffer_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   numbers = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   numbers_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   numbers_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   diagnostic = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   diagnostic_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   diagnostic_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   hint = {
        --     -- fg = "NONE",
        --     sp = "NONE",
        --     bg = "NONE",
        --   },
        --   hint_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   hint_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   hint_diagnostic = {
        --     -- fg = "NONE",
        --     sp = "NONE",
        --     bg = "NONE",
        --   },
        --   hint_diagnostic_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   hint_diagnostic_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   info = {
        --     -- fg = "NONE",
        --     sp = "NONE",
        --     bg = "NONE",
        --   },
        --   info_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   info_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   info_diagnostic = {
        --     -- fg = "NONE",
        --     sp = "NONE",
        --     bg = "NONE",
        --   },
        --   info_diagnostic_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   info_diagnostic_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   warning = {
        --     -- fg = "NONE",
        --     sp = "NONE",
        --     bg = "NONE",
        --   },
        --   warning_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   warning_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   warning_diagnostic = {
        --     -- fg = "NONE",
        --     sp = "NONE",
        --     bg = "NONE",
        --   },
        --   warning_diagnostic_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   warning_diagnostic_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   error = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --   },
        --   error_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   error_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   error_diagnostic = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --   },
        --   error_diagnostic_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   error_diagnostic_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     sp = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   modified = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   modified_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   modified_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   duplicate_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     italic = true,
        --   },
        --   duplicate_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     italic = true,
        --   },
        --   duplicate = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     italic = true,
        --   },
        --   separator_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   separator_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   separator = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   indicator_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   indicator_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   pick_selected = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   pick_visible = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   pick = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --     bold = true,
        --     italic = true,
        --   },
        --   offset_separator = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        --   trunc_marker = {
        --     -- fg = "NONE",
        --     bg = "NONE",
        --   },
        -- },

        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },

        always_show_bufferline = false, -- NOTE: to fix snacks dashboard showing empty buffer when first opening nvim.
        show_buffer_close_icons = false,
        show_close_icon = true,
        -- hover = {
        --   enabled = true,
        --   delay = 200,
        --   reveal = { "close" },
        -- },
        separator_style = { "", "" }, -- use this to remove the buggy lazyvim separator. ex. "slant" | "slope" | "thick" | "thin" | { "any", "any" }
      }

      require("bufferline").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      local pre_hook
      local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if loaded and ts_comment then
        pre_hook = ts_comment.create_pre_hook()
      end

      local ft = require("Comment.ft")

      -- 1. Using set function

      ft
        -- Set only line comment
        .set("hurl", "#%s")

      require("Comment").setup({
        ---Add a space b/w comment and the line
        padding = true,

        ---Whether the cursor should stay at its position
        sticky = true,

        ---Lines to be ignored while (un)comment
        ---Lines to be ignored while comment/uncomment.
        ---Could be a regex string or a function that returns a regex string.
        ---Example: Use '^$' to ignore empty lines
        ---@type string|function
        ignore = "^$",

        ---LHS of toggle mappings in NORMAL mode
        -- toggler = {
        --   ---Line-comment toggle keymap
        --   line = "gCc",
        --   ---Block-comment toggle keymap
        --   block = "gbc",

        --   -- ---Line-comment toggle keymap
        --   -- line = "gcc",
        --   -- ---Block-comment toggle keymap
        --   -- block = "gbc",
        -- },

        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        -- opleader = {
        -- ---Line-comment keymap
        -- line = "gC",
        -- -- line = "gc",
        -- ---Block-comment keymap
        -- block = "gb",
        -- },

        -- ---LHS of extra mappings
        -- extra = {
        --   ---Add comment on the line above
        --   -- above = "gcO",
        --   above = "gCO",
        --   ---Add comment on the line below
        --   below = "gCo",
        --   -- below = "gco",
        --   ---Add comment at the end of line
        --   eol = "gCA",
        --   -- eol = "gcA",
        -- },

        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings

        mappings = false,
        -- mappings = {
        --   ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        --   basic = true,
        --   ---Extra mapping; `gco`, `gcO`, `gcA`
        --   extra = true,
        -- },

        ---Function to call before (un)comment
        pre_hook = pre_hook,

        ---Function to call after (un)comment
        post_hook = nil,
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    keys = {
      -- stylua: ignore
      -- there is duplicate keymap to toggle git blame as the other is too deep inside a another prefix 'h'.
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = printf "Toggle Git Blame (virtual text)", mode = "n" },
    },
    opts = function(_, opts)
      -- change the default delay to 0.
      opts.current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 0,
        ignore_whitespace = false,
        virt_text_priority = 100,
        -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      }
    end, -- use this to not overwrite this plugin config (usefull in lazyvim)
  },

  {
    "cameron-wags/rainbow_csv.nvim",
    event = "VeryLazy",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "csv" })
      end

      -- disable csv highlighting as the treesitter has auto install. use the rainbow_csv.nvim highlighting instead.
      if type(opts.highlight.disable) == "table" then
        vim.list_extend(opts.highlight.disable, { "csv" })
      else
        opts.highlight.disable = { "csv" }
      end
    end,
  },

  {
    "theprimeagen/harpoon",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ha",
        function()
          vim.cmd("lua require('harpoon.mark').add_file()")
          vim.notify("add file to harpoon", vim.log.levels.INFO, { title = "harpoon" })
        end,
        desc = printf("Mark a File"),
      },
      { "<leader>hT", ":Telescope harpoon marks<cr>", desc = printf("Open Telescope Harpoon") },
      { "<leader>ht", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = printf("Open Quick Menu") }, -- NOTE: also for some golang repo which has many go.mod in a single git file it will not be able to show the harpooned files
      -- { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = printf"Go to next" },
      -- { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = printf"Go to previous" },
    },
    config = function(_, opts)
      require("harpoon").setup({
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,

        -- saves the harpoon file upon every change. disabling is unrecommended.
        save_on_change = true,

        -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
        enter_on_sendcmd = false,

        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
        tmux_autoclose_windows = false,

        -- filetypes that you want to prevent from adding to the harpoon list menu.
        excluded_filetypes = { "harpoon" },

        -- set marks specific to each git branch inside git repository
        mark_branch = false,

        -- enable tabline with harpoon marks
        tabline = false,
        tabline_prefix = "   ",
        tabline_suffix = "   ",
      })
      require("telescope").load_extension("harpoon")
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local wk = require("which-key")
      local mapping = {
        { "<leader>h", icon = "󱡀", group = printf("harpoon"), mode = "n" },
      }
      wk.add(mapping)
    end,
  },

  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    config = function()
      local printf = require("plugins.util.printf").printf

      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = printf("Spider-w") })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = printf("Spider-e") })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = printf("Spider-b") })
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = printf("Spider-ge") })

      -- default value
      require("spider").setup({
        skipInsignificantPunctuation = false,
      })
    end,
  },

  -- TODO: create whichky to show list of binding for nvim-surround

  -- local surround_add_msg = [[

  -- # add surround

  -- 'yziw*' new surround in word

  -- or

  -- 'yza**' new surround outside current surround

  -- mode: normal

  -- ---

  -- 'Z*'

  -- mode: visual

  -- ---

  -- ## special add surround

  -- 'yzz*' new surround in line

  -- or

  -- 'yZZ*' new surround new line (currently not working)

  -- mode: normal
  -- ]]
  {
    "kylechui/nvim-surround",
    version = "*", -- stability; omit for latest
    event = "VeryLazy",
    opts = function()
      local config = require("nvim-surround.config")

      return {
        keymaps = {
          insert = "<C-g>z",
          insert_line = "<C-g>Z",
          normal = "gs",
          normal_cur = "gss",
          normal_line = "gS",
          normal_cur_line = "gSS",
          visual = "gs",
          visual_line = "gS",
          delete = "gsd",
          change = "gsc",
          change_line = "gSc",
        },

        aliases = {
          ["a"] = ">",
          ["b"] = ")",
          ["B"] = "}",
          ["r"] = "]",
          ["q"] = { '"', "'", "`" },
          ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
        },

        surrounds = {
          ["l"] = {
            add = function()
              local clipboard = vim.fn.getreg("+"):gsub("\n", "")
              return {
                { "[" },
                { "](" .. clipboard .. ")" },
              }
            end,
          },

          ["c"] = {
            add = function()
              local lang = config.get_input("Enter code language (e.g., json): ")
              if lang == "" then
                print("Error: Language cannot be empty.")
                return nil
              end
              return {
                { "```" .. lang .. "\n" },
                { "\n```" },
              }
            end,
          },
        },
      }
    end,
  },

  -- {
  --   "johmsalas/text-case.nvim",
  --   event = "VeryLazy",
  --   opts = {}, -- or provide options if you need
  --   config = function(_, opts)
  --     require("textcase").setup(opts)

  --     -- TODO: the keymaps are in "ga" find a way to make better?
  --     -- require("telescope").load_extension("textcase")
  --     -- vim.api.nvim_set_keymap("n", "gaa", "<cmd>TextCaseOpenTelescope<CR>", { desc = printf("Telescope") })
  --     -- vim.api.nvim_set_keymap("v", "gai", "<cmd>TextCaseOpenTelescope<CR>", { desc = printf("Telescope") })

  --     vim.api.nvim_set_keymap("n", "<leader>cN", ":lua require('textcase').lsp_rename('to_constant_case')<CR>", { desc = printf("LSP Rename to Const Case") })
  --     vim.api.nvim_set_keymap("n", "<leader>cn", ":lua require('textcase').current_word('to_constant_case')<CR>", { desc = printf("Rename to Const Case") })
  --   end,
  -- }, -- DEL: . DELETE LINES LATER

  {
    "johmsalas/text-case.nvim",
    event = "VeryLazy",
    opts = {}, -- put setup options here if you need
    keys = {
      -- -- Telescope extension (normal + visual)
      -- { "gaa", "<cmd>TextCaseOpenTelescope<CR>", mode = "n", desc = "TextCase Telescope" },
      -- { "gai", "<cmd>TextCaseOpenTelescope<CR>", mode = "v", desc = "TextCase Telescope" },

      -- Constant case renaming
      {
        "<leader>cN",
        function()
          require("textcase").lsp_rename("to_constant_case")
        end,
        mode = "n",
        desc = "LSP Rename → CONST_CASE",
      },
      {
        "<leader>cn",
        function()
          require("textcase").current_word("to_constant_case")
        end,
        mode = "n",
        desc = "Rename word → CONST_CASE",
      },
    },
    config = function(_, opts)
      require("textcase").setup(opts)
      -- only need to load the telescope extension once
      -- require("telescope").load_extension("textcase")
    end,
  },

  -- {
  --   "aserowy/tmux.nvim",
  --   event = "VeryLazy",
  --   -- enabled = false, -- disabled plugin
  --   keys = {
  --     { "<c-h>", '<cmd>lua require("tmux").move_left()<cr>', mode = "n", desc = printf("tmux and nvim move left"), noremap = true, silent = true },
  --     { "<c-j>", '<cmd>lua require("tmux").move_bottom()<cr>', mode = "n", desc = printf("tmux and nvim move bottom"), noremap = true, silent = true },
  --     { "<c-k>", '<cmd>lua require("tmux").move_top()<cr>', mode = "n", desc = printf("tmux and nvim move top"), noremap = true, silent = true },
  --     { "<c-l>", '<cmd>lua require("tmux").move_right()<cr>', mode = "n", desc = printf("tmux and nvim move right"), noremap = true, silent = true },
  --   },
  --   config = function()
  --     return require("tmux").setup({
  --       copy_sync = {
  --         enable = false, -- to fix the issue when yanking in non-tmux and pressing 'p' inside tmux.
  --       },
  --     })
  --   end,
  -- }, -- DEL: . DELETE LINES LATER

  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
        mode = "n",
        desc = "tmux + nvim move left",
      },
      {
        "<C-j>",
        function()
          require("tmux").move_bottom()
        end,
        mode = "n",
        desc = "tmux + nvim move down",
      },
      {
        "<C-k>",
        function()
          require("tmux").move_top()
        end,
        mode = "n",
        desc = "tmux + nvim move up",
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
        mode = "n",
        desc = "tmux + nvim move right",
      },
    },
    opts = {
      copy_sync = {
        enable = false, -- avoids yank → paste conflicts outside tmux
      },
    },
  },

  {
    "echasnovski/mini.operators",
    version = "*",
    event = "VeryLazy",
    config = function(_, _)
      require("mini.operators").setup({
        -- Each entry configures one operator.
        -- `prefix` defines keys mapped during `setup()`: in Normal mode
        -- to operate on textobject and line, in Visual - on selection.

        -- Evaluate text and replace with output
        evaluate = {
          prefix = "g=",

          -- Function which does the evaluation
          func = nil,
        },

        -- Exchange text regions
        exchange = {
          prefix = "gx",

          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Multiply (duplicate) text
        multiply = {
          prefix = "gm",

          -- Function which can modify text before multiplying
          func = nil,
        },

        -- Replace text with register
        replace = {
          prefix = "gr",

          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Sort text
        sort = {
          prefix = "gS",

          -- Function which does the sort
          func = nil,
        },
      })
    end,
  },
  -- {
  --   "echasnovski/mini.files",
  --   opts = {
  --     options = {
  --       permanent_delete = false,
  --     },
  --   },
  -- },

  {
    "folke/noice.nvim",
    -- enabled = false,
    opts = {
      presets = {
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  -- NOTE: mini pairs has wierd behaviour when that adds unnessaccry pairs where it should not. it also failed when adding ``` as it will add ```` this many and need to manualy deleted.
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    enabled = false, -- disabled plugin
    opts = {
      indent = {
        char = char_symbol,
        tab_char = char_symbol,
      },
      scope = {
        enabled = true, -- This replaces 'show_current_context'
        show_start = true, -- Optional: customize context scope start
        highlight = { "Function", "Label" },
        show_end = false, -- Optional: hide context scope end. in case of lua, the 'end' in a function will be have underline highlight.
        -- show_exact_scope = true,
      },
      whitespace = {
        -- remove_blankline_trail = false,
      },
      -- scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "nvimtree",
          -- "markdown", -- frontmatter to behave strangely, but it is needed to make todo checkbox to have indent line.
          "snacks_notif",
          "snacks_terminal",
          "snacks_win",
        },
      },
    },
    main = "ibl",
  },
  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    enabled = false, -- disabled plugin
    event = "LazyFile",
    opts = {
      -- symbol = "▏",
      -- symbol = "│",
      symbol = char_symbol,
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "nvimtree",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  {
    -- live preview for the custom Norm (norm) command.
    "smjonas/live-command.nvim",
    event = "VeryLazy",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
        },
      })
    end,
  },
}
