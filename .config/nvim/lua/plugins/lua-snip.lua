local vscode_path = "~/.config/nvim/lua/vscode-snippets"
local snipmate_path = "~/.config/nvim/lua/snippets"
-- community driven of all programing language snippets
local honza_snippets_path = "~/.local/share/nvim/lazy/vim-snippets/snippets"
local printf = require("plugins.util.printf").printf

local friendly_snippets = {
  "rafamadriz/friendly-snippets",
  opts = function()
    require("luasnip.loaders.from_snipmate").lazy_load({ paths = { snipmate_path } })
    require("luasnip.loaders.from_vscode").lazy_load({ paths = vscode_path })
    require("luasnip.loaders.from_snipmate").lazy_load({ paths = { honza_snippets_path } })
  end,
}

return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    friendly_snippets,
    -- install honza's communty driven snippets. copy the path and use require 'from_snipmate' above to load it.
    { "honza/vim-snippets" },
  },
  opts = function(_, opts)
    opts.history = true
    opts.delete_check_events = "TextChanged"

    local types = require("luasnip.util.types")
    require("luasnip").config.setup({
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "●", "GruvboxOrange" } },
          },
        },
        [types.insertNode] = {
          active = {
            virt_text = { { "●", "GruvboxBlue" } },
          },
        },
      },
    })
  end,

  keys = {
    -- NOTE: dont bind c-i as most terminal will bind it as tab.
    -- this will be handled on cmp.nvim
    -- {
    --   "<tab>",
    --   function()
    --     return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    --   end,
    --   expr = true,
    --   silent = true,
    --   mode = "i",
    -- },
    -- { -- why tab again?
    --   "<tab>",
    --   function()
    --     require("luasnip").jump(1)
    --   end,
    --   mode = "s",
    -- },
    -- {
    --   "<s-tab>",
    --   function()
    --     require("luasnip").jump(-1)
    --   end,
    --   mode = {
    --     "i",
    --     "s",
    --   },
    -- },

    -- {
    --   "<tab>",
    --   function()
    --     require("luasnip").jump(1)
    --   end,
    --   mode = "s",
    -- },

    -- for luansip placeholder jumping. deprecated, cmp.nvim can now handle this if the current mode is snippets. the downside is to close cmp suggestion esc is needed.
    -- this can still be enable in case clicking 'esc' is still a hasle. 
    -- disable this if keyboard can have capslock as 'esc' (kanata and karabiner_elements).
    {
      "<C-G>",
      function()
        local luasnip = require("luasnip")
        if luasnip.jumpable() then
          luasnip.jump(-1)
        end
      end,
      desc = printf("Jump to previous placeholder (LuaSnip)"),
      noremap = true,
      silent = true,
      mode = {
        "v",
        "i",
      },
    },
    {
      "<C-H>",
      function()
        local luasnip = require("luasnip")
        if luasnip.jumpable() then
          luasnip.jump(1)
        end
      end,
      desc = printf("Jump to next placeholder (LuaSnip)"),
      noremap = true,
      silent = true,
      mode = {
        "v",
        "i",
      },
    },
  },
}
