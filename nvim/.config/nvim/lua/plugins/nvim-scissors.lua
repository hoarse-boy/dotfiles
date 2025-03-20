-- local chezmoi_dir = os.getenv("HOME") .. "/.local/share/chezmoi"

return {
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
            saveChanges = "<CR>", -- alternatively, can also use `:w`
            goBackToSearch = "<ESC>",
            deleteSnippet = "<Leader>D", -- it does not have prompt before deletion. proceed with caution
            duplicateSnippet = "<Leader>c", -- "<C-d>",
            openInFile = "<C-o>",
            insertNextPlaceholder = "<C-h>", -- insert & normal mode
            showHelp = "?",
          },
        },
        telescope = {
          -- By default, the query only searches snippet prefixes. Set this to
          -- `true` to also search the body of the snippets.
          alsoSearchSnippetBody = false,

          -- accepts the common telescope picker config
          opts = {
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = { width = 0.9 },
              preview_width = 0.6,
            },
          },
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
