local char_symbol = "▏"
-- local char_symbol = "▎"
-- local char_symbol = "▎"
-- local char_symbol = "▍"
-- local char_symbol = "┃"
-- local char_symbol = "│"

-- NOTE: best v2 with wezterm enable undercurl => https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
-- disable these plugins to use one plugin that can do both without mini.indentscope performance hit.

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "yaml", "yml", "toml" },
  callback = function()
    vim.b.snacks_indent = false
  end,
})

-- TODO: change to snacks.nvim if it has no bug.
return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        -- enabled = false, -- NOTE: enable or disable snacks indent
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
    },
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
}
