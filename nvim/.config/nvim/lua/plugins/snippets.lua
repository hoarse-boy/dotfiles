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

  -- update vscode style snippets
  {
    "chrisgrieser/nvim-scissors",
    event = "VeryLazy",
    -- enabled = false,
    dependencies = "nvim-telescope/telescope.nvim",
    config = function()
      -- default settings
      require("scissors").setup({
        -- snippetDir = chezmoi_dir .. "/dot_config/nvim/lua/vscode-snippets",
        snippetDir = vim.fn.stdpath("config") .. "/lua/vscode-snippets",
        editSnippetPopup = {
          height = 0.4, -- relative to the window, between 0-1
          width = 0.6,
          border = "rounded",
          keymaps = {
            -- if not mentioned otherwise, the keymaps apply to normal mode
            cancel = "q",
            saveChanges = ":w", -- alternatively, can also use `:w`
            -- saveChanges = "<CR>", -- alternatively, can also use `:w`
            goBackToSearch = "<ESC>",
            deleteSnippet = "<Leader>D", -- it does not have prompt before deletion. proceed with caution
            duplicateSnippet = "<Leader>c", -- "<C-d>",
            openInFile = "<C-o>",
            insertNextPlaceholder = "<C-h>", -- insert & normal mode
            showHelp = "?",
          },
        },
        snippetSelection = {
          -- telescope = {
          --   -- By default, the query only searches snippet prefixes. Set this to
          --   -- `true` to also search the body of the snippets.
          --   alsoSearchSnippetBody = false,

          --   -- accepts the common telescope picker config
          --   opts = {
          --     layout_strategy = "horizontal",
          --     layout_config = {
          --       horizontal = { width = 0.9 },
          --       preview_width = 0.6,
          --     },
          --   },
          -- },
        },

        -- `none` writes as a minified json file using `vim.encode.json`.
        -- `yq`/`jq` ensure formatted & sorted json files, which is relevant when
        -- you version control your snippets. To use a custom formatter, set to a
        -- list of strings, which will then be passed to `vim.system()`.
        ---@type "yq"|"jq"|"none"|string[]
        jsonFormatter = "none",

        backdrop = {
          enabled = true,
          blend = 50, -- between 0-100
        },
        icons = {
          scissors = "󰩫",
        },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local wk = require("which-key")
      local printf = require("plugins.util.printf").printf

      local mapping = {
        { "<leader>os", icon = "", group = printf("nvim-scissors"), mode = { "v", "n" } },
        { "<leader>osa", "<cmd>ScissorsAddNewSnippet<cr>", desc = printf("Scissors Add New Snippet"), mode = { "n", "v" }, icon = "" },
        { "<leader>ose", "<cmd>ScissorsEditSnippet<cr>", desc = printf("Scissors Edit Snippet"), mode = "n", icon = "" },
      }
      wk.add(mapping)
    end,
  },
}
