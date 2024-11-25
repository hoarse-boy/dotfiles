-- TODO: create whichky to show list of binding for nvim-surround

return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      local config = require("nvim-surround.config")

      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>z",
          insert_line = "<C-g>Z",
          normal = "yz",
          normal_cur = "yzz",
          normal_line = "yZ",
          normal_cur_line = "yZZ",
          visual = "z",
          visual_line = "gZ",
          delete = "dz",
          change = "cz",
          change_line = "cZ",
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
          ["*"] = {
            add = function()
              return {
                { "**" },
                { "**" },
              }
            end,
            find = "%*%*(.-)%*%*", -- FIX: not working
            delete = "%*%*(.-)%*%*", -- FIX: not working
          },
          -- ["tp"] = {
          --   add = function()
          --     return {
          --       { "<p>" },
          --       { "</p>" },
          --     }
          --   end,
          --   find = "%*%*(.-)%*%*", -- FIX: not working
          --   delete = "%*%*(.-)%*%*", -- FIX: not working
          -- },
          -- TODO: add more for markdown.
          ["l"] = {
            add = function()
              local clipboard = vim.fn.getreg("+"):gsub("\n", "")
              return {
                { "[" },
                { "](" .. clipboard .. ")" },
              }
            end,
            find = "%b[]%b()",
            delete = "^(%[)().-(%]%b())()$",
            change = {
              target = "^()()%b[]%((.-)()%)$",
              replacement = function()
                local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                return {
                  { "" },
                  { clipboard },
                }
              end,
            },
          },
          ["c"] = {
            add = function()
              local lang = config.get_input("Enter code language (e.g., json): ")
              return {
                { "```" .. lang .. "\n" },
                { "\n```" },
              }
            end,
            -- -- TODO: find out how to use the other like find etc. check this link for lua pattern https://www.lua.org/manual/5.4/manual.html#6.4.1
            -- -- also the "l" above is working and can be used as a reference.
            -- find = function()
            --   return require("nvim-surround.config").get_selections({
            --     char = "c",
            --     pattern = "(```%w*\n)().-()\n(```)",
            --   })
            -- end,
            -- delete = function()
            --   return require("nvim-surround.config").get_selections({
            --     char = "c",
            --     pattern = "(```%w*\n)().-()\n(```)",
            --   })
            -- end,
            -- change = {
            --   target = function()
            --     return require("nvim-surround.config").get_selections({
            --       char = "c",
            --       pattern = "(```%w*)().-()\n(```)",
            --     })
            --   end,
            --   replacement = function()
            --     local lang = vim.fn.input("Enter new code language (e.g., json): ")
            --     return {
            --       { "```" .. lang .. "\n" },
            --       { "\n```" },
            --     }
            --   end,
            -- },
          },
        },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local wk = require("which-key")
      local printf = require("plugins.util.printf").printf
      local autocmd = vim.api.nvim_create_autocmd
      local augroup = vim.api.nvim_create_augroup
      local surrounds_nvim = augroup("surrounds_nvim", {})

      autocmd("Filetype", {
        group = surrounds_nvim,
        pattern = "*", -- * for all filetypes
        callback = function()
          vim.schedule(function()
            local mapping = {
              -- uncomment to use examples below. -- NOTE:  is needed to not make it merge with other keymaps when opening other filetypes.
              -- { "<leader>k", icon = "", group = printf("nvim-surround"), mode = { "v", "n" }, buffer = 0 }, -- group key with prefix like '+'
              { "<leader>S", icon = "", group = printf("Surround Keys Cheatcodes"), mode = { "v", "n" } },

              -- stylua: ignore start
              { "<leader>Sc", "zc", desc = printf("Code Block (input)"), mode = "v" }, -- FIX:
              { "<leader>Sa", "", desc = printf("Surround add"), mode = "n", buffer = 0 }, -- FIX:
              { "<leader>Sb", function() print("hello") end, desc = "Foobar", buffer = 0 },

              -- FIX: add the following as whiechkey.
              -- {
              --   insert = "<C-g>z",
              --   insert_line = "<C-g>Z",
              --   normal = "yz",
              --   normal_cur = "yzz",
              --   normal_line = "yZ",
              --   normal_cur_line = "yZZ",
              --   visual = "z",
              --   visual_line = "gZ",
              --   delete = "dz",
              --   change = "cz",
              --   change_line = "cZ",
              -- }

              -- stylua: ignore end
            }
            wk.add(mapping)
          end)
        end,
      })
    end,
  },
}
