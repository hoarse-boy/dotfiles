local printf = require("plugins.util.printf").printf

local vscode_path = "~/.config/nvim/lua/vscode-snippets"
local my_snipmate_path = "~/.config/nvim/lua/snippets"
local lua_snippets = "~/.config/nvim/lua/luasnippets"
local honza_snippets_path = "~/.local/share/nvim/lazy/vim-snippets/snippets" -- community driven of all programing language snippets

return {
  -- disable builtin snippet support
  { "garymjr/nvim-snippets", enabled = false },

  -- add luasnip
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (not LazyVim.is_win()) and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp" or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },

    keys = {
      -- this is for luasnip placeholder jumping. this is still usefull if used alongside blink.cmp
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
  },

  -- add snippet_forward action and my snippets
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = { my_snipmate_path } })
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = { honza_snippets_path } })
      require("luasnip.loaders.from_vscode").lazy_load({ paths = vscode_path })
      require("luasnip.loaders.from_lua").load({ paths = lua_snippets })

      LazyVim.cmp.actions.snippet_forward = function()
        if require("luasnip").jumpable(1) then
          require("luasnip").jump(1)
          return true
        end
      end
    end,
  },

  -- nvim-cmp integration
  -- {
  --   "nvim-cmp",
  --   optional = true,
  --   dependencies = { "saadparwaiz1/cmp_luasnip" },
  --   opts = function(_, opts)
  --     opts.snippet = {
  --       expand = function(args)
  --         require("luasnip").lsp_expand(args.body)
  --       end,
  --     }
  --     table.insert(opts.sources, { name = "luasnip" })
  --   end,
  --   -- stylua: ignore
  --   keys = {
  --     { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
  --     { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  --   },
  -- },

  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      accept = {
        expand_snippet = function(...)
          return require("luasnip").lsp_expand(...)
        end,
      },
    },
  },
}

-- local vscode_path = "~/.config/nvim/lua/vscode-snippets"
-- local my_snipmate_path = "~/.config/nvim/lua/snippets"
-- -- community driven of all programing language snippets
-- local honza_snippets_path = "~/.local/share/nvim/lazy/vim-snippets/snippets"
-- local printf = require("plugins.util.printf").printf

-- local friendly_snippets = {
--   "rafamadriz/friendly-snippets",
--   opts = function()
--     require("luasnip.loaders.from_snipmate").lazy_load({ paths = { my_snipmate_path } })
--     require("luasnip.loaders.from_vscode").lazy_load({ paths = vscode_path })
--     require("luasnip.loaders.from_snipmate").lazy_load({ paths = { honza_snippets_path } })
--   end,
-- }

-- return {
--   "L3MON4D3/LuaSnip",
--   dependencies = {
--     friendly_snippets,
--     -- install honza's communty driven snippets. copy the path and use require 'from_snipmate' above to load it.
--     { "honza/vim-snippets" },
--   },
--   opts = function(_, opts)
--     opts.history = true
--     opts.delete_check_events = "TextChanged"

--     require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/luasnippets" })
--     -- /Users/oktagon-jourdy/.config/nvim/lua/luasnippets

--     local types = require("luasnip.util.types")
--     require("luasnip").config.setup({
--       ext_opts = {
--         [types.choiceNode] = {
--           active = {
--             virt_text = { { "●", "GruvboxOrange" } },
--           },
--         },
--         [types.insertNode] = {
--           active = {
--             virt_text = { { "●", "GruvboxBlue" } },
--           },
--         },
--       },
--     })
--   end,

--   keys = {
--     -- NOTE: dont bind c-i as most terminal will bind it as tab.
--     -- this will be handled on cmp.nvim
--     -- {
--     --   "<tab>",
--     --   function()
--     --     return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
--     --   end,
--     --   expr = true,
--     --   silent = true,
--     --   mode = "i",
--     -- },
--     -- { -- why tab again?
--     --   "<tab>",
--     --   function()
--     --     require("luasnip").jump(1)
--     --   end,
--     --   mode = "s",
--     -- },
--     -- {
--     --   "<s-tab>",
--     --   function()
--     --     require("luasnip").jump(-1)
--     --   end,
--     --   mode = {
--     --     "i",
--     --     "s",
--     --   },
--     -- },

--     -- {
--     --   "<tab>",
--     --   function()
--     --     require("luasnip").jump(1)
--     --   end,
--     --   mode = "s",
--     -- },

--     -- for luansip placeholder jumping. deprecated, cmp.nvim can now handle this if the current mode is snippets. the downside is to close cmp suggestion esc is needed.
--     -- this can still be enable in case clicking 'esc' is still a hasle.
--     -- disable this if keyboard can have capslock as 'esc' (kanata and karabiner_elements).
--     {
--       "<C-G>",
--       function()
--         local luasnip = require("luasnip")
--         if luasnip.jumpable() then
--           luasnip.jump(-1)
--         end
--       end,
--       desc = printf("Jump to previous placeholder (LuaSnip)"),
--       noremap = true,
--       silent = true,
--       mode = {
--         "v",
--         "i",
--       },
--     },
--     {
--       "<C-H>",
--       function()
--         local luasnip = require("luasnip")
--         if luasnip.jumpable() then
--           luasnip.jump(1)
--         end
--       end,
--       desc = printf("Jump to next placeholder (LuaSnip)"),
--       noremap = true,
--       silent = true,
--       mode = {
--         "v",
--         "i",
--       },
--     },
--   },
-- }
