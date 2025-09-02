-- return {
--   "folke/tokyonight.nvim",
--   -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   -- priority = 1000, -- make sure to load this before all the other start plugins
--   event = "VeryLazy",
--   config = function()
--     require("tokyonight").setup({
--       -- your configuration comes here
--       -- or leave it empty to use the default settings
--       style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
--       light_style = "day", -- The theme is used when the background is set to light
--       transparent = true, -- Enable this to disable setting the background color
--       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
--       styles = {
--         -- Style to be applied to different syntax groups
--         -- Value is any valid attr-list value for `:help nvim_set_hl`
--         comments = { italic = true },
--         keywords = { italic = true },
--         functions = {},
--         variables = {},
--         -- Background styles. Can be "dark", "transparent" or "normal"
--         sidebars = "dark", -- style for sidebars, see below
--         floats = "dark", -- style for floating windows
--       },
--       sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
--       day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
--       hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
--       dim_inactive = false, -- dims inactive windows
--       lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

--       --- You can override specific color groups to use other groups or a hex color
--       --- function will be called with a ColorScheme table
--       ---@param colors ColorScheme
--       on_colors = function(colors) end,

--       --- You can override specific highlights to use other groups or a hex color
--       --- function will be called with a Highlights and ColorScheme table
--       ---@param highlights Highlights
--       ---@param colors ColorScheme
--       on_highlights = function(highlights, colors) end,
--     })
--   end,
-- }

local hl_colors = {
  dark_blue = "#0286c7",
  types = "#2b8756",
  todo_NOTE = "#15a191",
  todo_TODO = "#18a4db",
  todo_WARN = "#b0ab8b",
  todo_HACK = "#7833f5",
  todo_FIX = "#d4284a",
}

return {
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    -- event = "VimEnter",
    priority = 1000,

    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, night, moon, day
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = {},
          functions = { italic = true },
          variables = {},
          sidebars = "transparent",
          floats = "transparent",
        },
        on_highlights = function(hl, c)
          -- Base comment and backdrop
          hl.Comment = { fg = "#4d4b49" }
          hl.FlashBackdrop = { fg = "#4d4b49" }

          -- Operator and basic syntax
          hl.Operator = { fg = "#99875c" }
          hl.Boolean = { fg = "#7833f5" }
          hl.Number = { fg = "#87b7c7" }
          hl.Type = { fg = hl_colors.types }
          hl.Identifier = { fg = "#5885b0" }
          hl["@parameter"] = { fg = "#9c4528" }

          -- String/url
          hl["@string.special.url"] = { fg = "#a89996" }

          -- Visual selection
          hl.Visual = { bg = "#292930" }

          -- LSP + inlay hints
          hl.LspInlayHint = { fg = "#3e4d4c" }

          -- Todo highlights
          hl.TodoBgNOTE = { bold = true, bg = hl_colors.todo_NOTE, fg = "#000000" }
          hl.TodoSignNOTE = { fg = hl_colors.todo_NOTE }
          hl.TodoFgNOTE = { fg = hl_colors.todo_NOTE }

          hl.TodoBgTODO = { bold = true, bg = hl_colors.todo_TODO, fg = "#000000" }
          hl.TodoSignTODO = { fg = hl_colors.todo_TODO }
          hl.TodoFgTODO = { fg = hl_colors.todo_TODO }

          hl.TodoBgWARN = { bold = true, bg = hl_colors.todo_WARN, fg = "#000000" }
          hl.TodoSignWARN = { fg = hl_colors.todo_WARN }
          hl.TodoFgWARN = { fg = hl_colors.todo_WARN }

          hl.TodoBgHACK = { bold = true, bg = hl_colors.todo_HACK, fg = "#000000" }
          hl.TodoSignHACK = { fg = hl_colors.todo_HACK }
          hl.TodoFgHACK = { fg = hl_colors.todo_HACK }

          hl.TodoBgFIX = { bold = true, bg = hl_colors.todo_FIX, fg = "#000000" }
          hl.TodoSignFIX = { fg = hl_colors.todo_FIX }
          hl.TodoFgFIX = { fg = hl_colors.todo_FIX }

          -- Rainbow delimiters
          hl.RainbowDelimiterGreen = { fg = "#0d8c4f" }
          hl.rainbow4 = { link = "RainbowDelimiterGreen" }
          hl.rainbowcol7 = { link = "RainbowDelimiterGreen" }
          hl.RainbowDelimiterViolet = { link = "rainbowcol5" }
          hl.rainbow6 = { link = "rainbowcol5" }

          -- Golang specific
          hl["@variable.builtin"] = { fg = "#d61c9f" }
          hl["@type.builtin"] = { fg = "#5e7843" }
          hl.goStructTypeField = { fg = "#10b7c7" }
          hl.goVarAssign = { fg = "#D7658B" }
          hl.PreProc = { fg = "#9c9797" }
          hl.goStringFormat = { fg = "#10b7c7" }

          -- Rust specific
          hl["@punctuation.special"] = { fg = "#10b7c7" }
          hl["@string.special"] = { fg = "#10b7c7" }
          hl["@lsp.typemod.function.defaultLibrary"] = { fg = "#0286c7" }
          hl["@lsp.typemod.macro.defaultLibrary"] = { fg = "#94e2d5" }
          hl["@constant.builtin"] = { link = "Type" }
        end,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
