-- TODO: create whichky to show list of binding for nvim-surround

local surround_add_msg = [[

# add surround

'yziw*' new surround in word

or

'yza**' new surround outside current surround

mode: normal

---

'Z*'

mode: visual

---

## special add surround

'yzz*' new surround in line

or

'yZZ*' new surround new line (currently not working)

mode: normal
]]

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
            find = "%*%*(.-)%*%*", -- NOTE: not working
            delete = "%*%*(.-)%*%*",
          },

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

      local surround_nvim_title_msg = "surround-nvim"

      local mapping = {
        { "<leader>oS", icon = "", group = printf("Surround Keys Cheatcodes"), mode = "n" },

        -- stylua: ignore start
        { "<leader>oSC",
          function() vim.notify("\n# add code block\n\n'zc'\nmode: v-line", vim.log.levels.INFO, { title = surround_nvim_title_msg })
          end, desc = printf("Code Block (v-line mode)"), mode = "n"
        },

        { "<leader>oSc",
          function() vim.notify("\n# change surround\n\n'cz**'\nmode: normal\n\nfirst * is target\nsecond * is replacement", vim.log.levels.INFO, { title = surround_nvim_title_msg })
          end, desc = printf("Change Surround"), mode = "n"
        },

        { "<leader>oSa",
          function() vim.notify(surround_add_msg, vim.log.levels.INFO, { title = surround_nvim_title_msg })
          end, desc = printf("Add Surround (most commond)"), mode = "n"
        },

        { "<leader>oSd",
          function() vim.notify("\n# delete surround\n\n'dz*'\nmode: normal\n", vim.log.levels.INFO, { title = surround_nvim_title_msg })
          end, desc = printf("Delete Surround"), mode = "n"
        },
        -- stylua: ignore end
      }
      wk.add(mapping)
    end,
  },
}
