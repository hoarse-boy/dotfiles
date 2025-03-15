local my_vscode_path = "~/.config/nvim/lua/vscode-snippets"
local my_snipmate_path = "~/.config/nvim/lua/snippets"
local my_lua_snippets = "~/.config/nvim/lua/luasnippets"
local honza_snippets_path = "~/.local/share/nvim/lazy/vim-snippets/snippets" -- community driven of all programing language snippets

-- must install default lazyvim's luasnip form LazyExtra
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
    opts = function(_, opts)
      opts.history = true
      opts.delete_check_events = "TextChanged"

      require("luasnip.loaders.from_snipmate").lazy_load({ paths = { my_snipmate_path, honza_snippets_path } })
      require("luasnip.loaders.from_lua").lazy_load({ paths = { my_lua_snippets } })
      require("luasnip.loaders.from_vscode").lazy_load({ paths = my_vscode_path })
    end,
    keys = {},
  },
}
