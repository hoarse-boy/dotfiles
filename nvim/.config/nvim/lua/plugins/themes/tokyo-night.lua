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
  stringEscape = "#5e7843",
}

return {
  {
    "folke/tokyonight.nvim",
    -- name = "tokyonight",
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

        on_colors = function(colors)
          -- These are like "color_overrides" in Catppuccin
          -- colors.peach = "#da8ede" -- number
          -- colors.text = "#c7c7c7" -- variables / text
          colors.red = "#a10524"
          colors.green = "#ad7666" -- strings
          colors.blue = "#0286c7" -- functions, titles
          -- colors.pink = "#8d5afa" -- special funcs
          -- colors.lavender = "#10b7c7" -- identifiers
          -- colors.mauve = "#d42f62" -- return, exception
          -- You can override any base color Tokyonight defines here
        end,

        on_highlights = function(hl, c)
          -- Base comment and backdrop
          hl.Comment = { fg = "#4d4b49" }
          hl.FlashBackdrop = { fg = "#4d4b49" }
          hl.Statement = { fg = "#8d60e0" } -- global if, else, switch, case, default, return, defer, for, while, do, until and etc.

          -- Operator and basic syntax
          -- hl.Operator = { fg = "#99875c" }
          hl.Boolean = { fg = "#7833f5" }
          hl.Number = { fg = "#BDB76B" }
          -- hl.Number = { fg = "#87b7c7" }
          hl.Type = { fg = hl_colors.types }
          hl.Identifier = { fg = "#5885b0" }
          -- hl["@lsp.type.parameter"] = { fg = "#9c4528" } -- parameter by lsp
          hl["@variable.parameter"] = { fg = "#9c4528" } -- parameter by treesitter

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

          -- example colors
          -- palevioletred      #DB7093
          -- pink               #FFC0CB
          -- lightpink          #FFB6C1
          -- snow               #FFFAFA
          -- rosybrown          #BC8F8F
          -- lightcoral         #F08080
          -- crimson            #DC143C
          -- indianred          #CD5C5C
          -- mistyrose          #FFE4E1
          -- brown              #A52A2A
          -- salmon             #FA8072
          -- firebrick          #B22222
          -- maroon             #800000
          -- tomato             #FF6347
          -- darkred            #8B0000
          -- red                #FF0000
          -- darksalmon         #E9967A
          -- orangered          #FF4500
          -- coral              #FF7F50
          -- lightsalmon        #FFA07A
          -- sienna             #A0522D
          -- chocolate          #D2691E
          -- saddlebrown        #8B4513
          -- sandybrown         #F4A460
          -- darkorange         #FF8C00
          -- seashell           #FFF5EE
          -- peru               #CD853F
          -- peachpuff          #FFDAB9
          -- orange             #FFA500
          -- linen              #FAF0E6
          -- burlywood          #DEB887
          -- bisque             #FFE4C4
          -- tan                #D2B48C
          -- antiquewhite       #FAEBD7
          -- navajowhite        #FFDEAD
          -- darkgoldenrod      #B8860B
          -- blanchedalmond     #FFEBCD
          -- goldenrod          #DAA520
          -- moccasin           #FFE4B5
          -- papayawhip         #FFEFD5
          -- wheat              #F5DEB3
          -- oldlace            #FDF5E6
          -- floralwhite        #FFFAF0
          -- gold               #FFD700
          -- cornsilk           #FFF8DC
          -- khaki              #F0E68C
          -- darkkhaki          #BDB76B
          -- olive              #808000
          -- yellow             #FFFF00
          -- palegoldenrod      #EEE8AA
          -- lemonchiffon       #FFFACD
          -- lightgoldenrodyellow #FAFAD2
          -- lightyellow        #FFFFE0
          -- beige              #F5F5DC
          -- ivory              #FFFFF0
          -- olivedrab          #6B8E23
          -- yellowgreen        #9ACD32
          -- darkolivegreen     #556B2F
          -- greenyellow        #ADFF2F
          -- chartreuse         #7FFF00
          -- lawngreen          #7CFC00
          -- darkgreen          #006400
          -- green              #008000
          -- lime               #00FF00
          -- limegreen          #32CD32
          -- forestgreen        #228B22
          -- palegreen          #98FB98
          -- lightgreen         #90EE90
          -- darkseagreen       #8FBC8F
          -- honeydew           #F0FFF0
          -- springgreen        #00FF7F
          -- seagreen           #2E8B57
          -- mediumseagreen     #3CB371
          -- mediumspringgreen  #00FA9A
          -- mintcream          #F5FFFA
          -- mediumaquamarine   #66CDAA
          -- aquamarine         #7FFFD4
          -- turquoise          #40E0D0
          -- lightseagreen      #20B2AA
          -- mediumturquoise    #48D1CC
          -- aqua               #00FFFF
          -- darkcyan           #008B8B
          -- teal               #008080
          -- darkslategray      #2F4F4F
          -- paleturquoise      #AFEEEE
          -- darkturquoise      #00CED1
          -- lightcyan          #E0FFFF
          -- azure              #F0FFFF
          -- cadetblue          #5F9EA0
          -- powderblue         #B0E0E6
          -- lightblue          #ADD8E6
          -- skyblue            #87CEEB
          -- deepskyblue        #00BFFF
          -- lightskyblue       #87CEFA
          -- aliceblue          #F0F8FF
          -- slategray          #708090
          -- lightslategray     #778899
          -- steelblue          #4682B4
          -- lightsteelblue     #B0C4DE
          -- dodgerblue         #1E90FF
          -- cornflowerblue     #6495ED
          -- ghostwhite         #F8F8FF
          -- lavender           #E6E6FA
          -- royalblue          #4169E1
          -- darkgray           #A9A9A9
          -- dimgray            #696969
          -- gainsboro          #DCDCDC
          -- gray               #808080
          -- lightgray          #D3D3D3
          -- silver             #C0C0C0
          -- white              #FFFFFF
          -- whitesmoke         #F5F5F5
          -- darkslateblue      #483D8B
          -- slateblue          #6A5ACD
          -- mediumslateblue    #7B68EE
          -- midnightblue       #191970
          -- blue               #0000FF
          -- darkblue           #00008B
          -- mediumblue         #0000CD
          -- navy               #000080
          -- mediumpurple       #9370DB
          -- rebeccapurple      #663399
          -- blueviolet         #8A2BE2
          -- indigo             #4B0082
          -- darkorchid         #9932CC
          -- darkviolet         #9400D3
          -- mediumorchid       #BA55D3
          -- thistle            #D8BFD8
          -- plum               #DDA0DD
          -- violet             #EE82EE
          -- orchid             #DA70D6
          -- darkmagenta        #8B008B
          -- fuchsia            #FF00FF
          -- purple             #800080
          -- mediumvioletred    #C71585
          -- hotpink            #FF69B4
          -- lavenderblush      #FFF0F5
          -- deeppink           #FF1493
          -- all languages
          hl["@lsp.type.escapeSequence"] = { fg = hl_colors.stringEscape, bold = true }
          hl["@lsp.typemod.function.generic"] = { fg = "#2b5db5" }
          hl["@lsp.typemod.method.defaultLibrary"] = { link = "@lsp.typemod.function.generic" }
          hl["@lsp.type.method"] = { link = "@lsp.typemod.function.generic" }
          hl["@keyword.import"] = { fg = "#10b7c7" }
          hl["@keyword"] = { fg = "#d42f62" }
          hl["@lsp.type.keyword"] = {} -- lsp keyword like fn, if, defer etc. but treesitter has different naming for if vs fn
          hl["@lsp.type.namespace"] = { fg = "#5F9EA0", italic = true } -- go package name and rust use package::

          -- hl["@lsp.type.namespace"] = { fg = "#7DCFFF", italic = true } -- go package name and rust use package::
          hl["@lsp.typemod.macro.library"] = { fg = "#9C9797" }
          hl["@lsp.typemod.macro.defaultLibrary"] = { fg = "#9C9797" }
          hl["@lsp.type.operator"] = { fg = "#dedfe0" } -- &, *, =, := and etc. need to have different color as points and reference will be next to a var or types.
          hl["@lsp.type.property"] = { fg = "#82bacc" }
          hl["@keyword.exception"] = { fg = "#99875c" } -- throw, try, catch, finally
          hl["@keyword.conditional"] = { fg = "#8d60e0" } -- if, else, switch, case, default
          hl["@keyword.repeat"] = { fg = "#8d60e0" } -- for, while, do, until
          hl.Constant = { fg = "#915d41" }
          -- #9D7CD8 can be used

          -- Golang specific
          hl["@variable.builtin"] = { fg = "#d61c9f" }
          hl["@lsp.typemod.string.format"] = { fg = "#10b7c7" }
          hl["@lsp.type.string.go"] = {} -- to fix the \n or escape string to be highlighted, as this has high priority agains the goStringEscape
          hl.goStringEscape = { fg = hl_colors.stringEscape, bold = true } -- this is available using charlespascoe/vim-go-syntax plugin
          hl["@type.builtin"] = { fg = "#5e7843" }
          hl.goStructTypeField = { fg = "#10b7c7" }
          hl.goVarAssign = { fg = "#D7658B" }
          hl.PreProc = { fg = "#9c9797" }
          hl.goStringFormat = { fg = "#10b7c7" }
          hl["goFuncDecl"] = { fg = "#d42f62" }
          hl["goImport"] = { fg = "#d42f62" }
          hl["goReturn"] = { fg = "#d42f62" }
          hl["goPackage"] = { fg = "#0286c7" }
          hl["goFuncBlock"] = { link = "Identifier" } -- var
          hl["goStructLiteralBlock"] = { link = "Identifier" } -- var that contains a struct
          hl["goFuncCallArgs"] = { link = "Identifier" } -- var that is inside a function call as parameter
          hl["goStructLiteralField"] = { fg = "#dedfe0" } -- a field inside a struct
          hl["goField"] = { fg = "#dedfe0" } -- a field inside a func parameter
          hl["@lsp.typemod.type.defaultLibrary"] = { fg = "#915d41" }

          -- Rust specific
          hl["@punctuation.special"] = { fg = "#10b7c7" }
          hl["@string.special"] = { fg = "#10b7c7" }
          hl["@lsp.typemod.function.defaultLibrary"] = { fg = "#0286c7" }
          -- hl["@lsp.typemod.macro.defaultLibrary"] = { fg = "#94e2d5" }
          hl["@constant.builtin"] = { link = "Type" }

          -- TS specific
          hl["@lsp.type.enumMember.typescript"] = { fg = "#915d41" }
          hl["@lsp.typemod.interface.declaration.typescript"] = { fg = "#008B8B" }
          hl["@lsp.type.interface.typescript"] = { fg = "#008B8B" }

          -- others
          hl["TreesitterContext"] = { bg = "NONE" }
          hl["StatusLine"] = { bg = "NONE" } -- to remove lualine statusline highlights
          hl["TabLineFill"] = { bg = "NONE" } -- to remove tabline highlights (bufferline)
        end,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
