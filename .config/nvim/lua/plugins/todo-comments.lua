local printf = require("plugins.util.printf").printf
-- local append_fix_str = "FIX: " -- NOTE: '.' is used to avoid formatter to remove white space.
-- local append_fix_str = "FIX: . " -- NOTE: '.' is used to avoid formatter to remove white space.
local append_del_str = "DEL: . "

-- other keymaps for marking buffer are here.
return {
  {
    "folke/todo-comments.nvim",
    opts = function(_, opts)
      opts.merge_keywords = true -- when true, custom keywords will be merged with the defaults

      -- add my custom todo.
      opts.keywords = {
        MARKED = {
          icon = "󰓾", -- "󰣉"
          color = "mark",
          -- signs = false, -- configure signs for some keywords individually
        },
        DEL = {
          icon = "󱂥",
          color = "del",
          -- signs = false, -- configure signs for some keywords individually
        },
      }

      opts.colors = {
        mark = { "marked-hl", "#d0d2d6" },
        del = { "del-hl", "#d47028" },
      }

      -- here are the list of default keywords
      -- FIX:
      -- FIXME:
      -- BUG:
      -- FIXIT:
      -- ISSUE:
      -- NOTE:
      -- WARN:
      -- TODO:
      -- HACK:
      -- PERF:
      -- TEST:

      -- custom keywords
      -- MARKED: as harpoon alternative to jump to the line using trouble
      -- DEL: to be used to delete the line.
    end,
    keys = {
      {
        "<leader>mm",
        function()
          require("plugins.util.custom_todo_comments").insert_custom_todo_comments()
        end,
        mode = "n",
        desc = printf("Insert MARKED todo"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mf", -- TODO: change the insert_custom_todo_comments func to not add new line but add to the right as comments? if lang is not availabl, create new line.
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(nil, "", false)
        end,
        mode = "n",
        desc = printf("Insert 'FIX'"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mc",
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(nil, "Check and test this. remove comments later", false)
        end,
        mode = "n",
        desc = printf("Insert 'FIX Check and Test'"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>md",
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(append_del_str, "DELETE LINES LATER", false)
          -- require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(string.format("%s%s", append_del_str, ""), false)
        end,
        mode = "n",
        desc = printf("Insert 'DEL'"),
        noremap = true, -- FIX:
        silent = true,
      },
      {
        "<leader>mi", -- TODO: change the insert_custom_todo_comments func to not add new line but add to the right as comments? if lang is not availabl, create new line.
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(nil, "", true)
        end,
        mode = "n",
        desc = printf("Insert 'FIX' and Insert Mode"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mr",
        function()
          require("plugins.util.custom_todo_comments").remove_fix_comments_from_current_line()
        end,
        mode = { "v", "n" }, -- FIX: visual is still buggy.
        desc = printf("Remove 'FIX' Comment"),
        noremap = true,
        silent = true,
      },
      -- TODO: change todo telescopt and trouble.
      -- for example make 'mt' to be regular tele to search MARKED.
      -- but make mT to be telescopte to show selection first such as 'MARKED' and then 'FIXED' and search using telescope.
      {
        "<leader>mt",
        "<cmd>TodoTelescope keywords=MARKED<cr>",
        mode = "n",
        desc = printf("Telescope Open 'MARKED' Todo"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mT",
        "<cmd>Trouble todo filter = {tag = {MARKED}}<cr>",
        mode = "n",
        desc = printf("Trouble Open 'MARKED' Todo"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mF",
        "<cmd>Trouble todo filter = {tag = {FIX, DEL, MARKED}}<cr>",
        mode = "n",
        desc = printf("Trouble Open 'FIX', 'DEL', and 'MARKED' Todo"), -- FIX:
        noremap = true,
        silent = true,
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local wk = require("which-key")
      local mapping = {
        { "<leader>m", icon = "󰓾", group = printf("todo marker"), mode = "n" },
      }
      wk.add(mapping)
    end,
  },
}
