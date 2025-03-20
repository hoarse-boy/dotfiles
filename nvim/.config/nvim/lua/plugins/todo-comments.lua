local printf = require("plugins.util.printf").printf
-- local append_fix_str = "FIX: " -- NOTE: '.' is used to avoid formatter to remove white space.
-- local append_fix_str = "FIX: . " -- NOTE: '.' is used to avoid formatter to remove white space.
local append_del_str = "DEL: . "
-- local uncomment_str = "UNCOMMENT: . "

-- DEL: . DELETE LINES LATER
local function capture_visual_selection()
  -- Get start and end positions of visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Get selected lines
  local lines = vim.api.nvim_buf_get_lines(
    0,
    start_pos[2] - 1, -- Convert from 1-indexed to 0-indexed
    end_pos[2], -- Inclusive end
    false
  )

  -- Join and store as before
  local content = table.concat(lines, "\n")
  vim.fn.setreg("a", content)
  vim.g.captured_content = content

  vim.notify("Captured selection to register 'a'", vim.log.levels.INFO)
  return content
end

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
        UNCOMMENT = {
          icon = "󰅽",
          color = "uncomment",
          -- signs = false, -- configure signs for some keywords individually
        },
      }

      opts.colors = {
        mark = { "marked-hl", "#d0d2d6" },
        del = { "del-hl", "#d47028" },
        uncomment = { "uncomment-hl", "#663820" },
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
      -- UNCOMMENT: to be used as sign to uncomment it later.
    end,
    keys = {
      {
        "<leader>mm",
        function()
          require("plugins.util.custom_todo_comments").insert_custom_todo_comments()
        end,
        mode = "n",
        desc = printf("Break line and Append MARKED todo"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mf", -- TODO: change the insert_custom_todo_comments func to not add new line but add to the right as comments? if lang is not availabl, create new line.
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(nil, "", false)
        end,
        mode = "n",
        desc = printf("Append 'FIX' (Normal Mode)"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mc",
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(nil, "Check and test this. remove comments later", false)
        end,
        mode = "n",
        desc = printf("Append 'FIX Check and Test'"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mw",
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(nil, "follow up / is pending", false)
        end,
        mode = "n",
        desc = printf("Append 'FIX follow up / is pending'"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mu",
        function()
          require("plugins.util.custom_todo_comments").toggle_uncomment_comment()
        end,
        mode = "n",
        desc = printf("Uncomment and remove 'UNCOMMENT' comment in current line"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>md",
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(append_del_str, "DELETE LINES LATER", false)
        end,
        mode = "n",
        desc = printf("Append 'DEL'"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mi", -- TODO: change the insert_custom_todo_comments func to not add new line but add to the right as comments? if lang is not availabl, create new line.
        function()
          require("plugins.util.custom_todo_comments").append_todo_comments_to_current_line(nil, "", true)
        end,
        mode = "n",
        desc = printf("Insert 'FIX'"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mr",
        function()
          require("plugins.util.custom_todo_comments").remove_fix_comments_from_current_line()
        end,
        mode = "n",
        desc = printf("Remove 'FIX' Comment"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mr",
        function()
          capture_visual_selection() -- FIX: . Check and test this. remove comments later
          -- require("plugins.util.custom_todo_comments").remove_todo_comments_from_visual_selection()
        end,
        mode = "v",
        desc = printf("Remove 'FIX' Comment"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mM",
        -- stylua: ignore
         function () Snacks.picker.todo_comments({ keywords = { "MARKED" } }) end,
        mode = "n",
        desc = printf("Open List of 'MARKED' Todo"),
        noremap = true,
        silent = true,
      },
      {
        "<leader>mt",
        -- stylua: ignore
         function () Snacks.picker.todo_comments({ keywords = { "FIX", "TODO", "DEL", "MARKED", "UNCOMMENT" } }) end,
        mode = "n",
        desc = printf("Open List of 'FIX', 'TODO', 'DEL', 'MARKED', and 'UNCOMMENT' Todo"),
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
        desc = printf("Trouble Open 'FIX', 'DEL', and 'MARKED' Todo"),
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
