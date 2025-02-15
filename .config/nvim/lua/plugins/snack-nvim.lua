local my_notes_dir = "~/jho-notes"
local printf = require("plugins.util.printf").printf

-- all snacks.nvim configs goes here
return {
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      -- scratch buffer
      scratch = {
        name = "quick-note",
        file = my_notes_dir .. "/quick-note.md", -- use this to avoid strange name generated
        ft = "markdown",
        icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
        -- root = my_notes_dir, -- will use 'file' property instead
        -- root = vim.fn.stdpath("data") .. "/scratch", -- default
        autowrite = true, -- automatically write when the buffer is hidden
        filekey = {
          cwd = false, -- use current working directory
          branch = false, -- use current branch name
          count = false, -- use vim.v.count1
        },
        win = { style = "scratch" },
      },

      -- picker and explorer has the same config. hidden is true will make both explorer and picker hidden files to show up.
      -- any config here will overwrite to all pickers. such as args, be careful.
      picker = {
        hidden = true, -- explorer will not display files that are gitignored. to open those files, use picker.files.
        -- args = {} -- NOTE: don't add any args here as this is will overwrite to all sources / pickers

        matcher = {
          frecency = true,
        },

        -- sources contains all of the pickers table. such as files, grep, todo_comments which are all default sources or pickers.
        -- add new table to create custom pickers.
        sources = {
          -- overwrite the default 'files' picker to exclude some files and show hidden files
          files = {
            cmd = "fd",
            hidden = true, -- explorer will not display files that are gitignored. to open those files, use picker.files.
            -- stylua: ignore start
            args = {
              "--type", "f",          -- search for files
              "--hidden",             -- include hidden files and directories
              "--no-ignore",          -- include files ignored by .gitignore. example of this is to make launch.json to shows up.
              "--exclude", ".git",
              "--exclude", "node_modules",
              "--exclude", "vendor",
              "--exclude", "*.pb.go",
            },
            -- stylua: ignore end
          },

          -- example of creating new custom picker
          -- custom_picker = {}
        },

        debug = {
          scores = false, -- show scores in the list. debugging only
        },
      },

      -- snacks notifier
      -- TODO: add snack-notifier config her
    },
    keys = {
      -- stylua: ignore
      { "<leader>.",  function() Snacks.scratch() end, desc = printf("Toggle 'quick-note' Buffer") },
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local wk = require("which-key")
      local mapping = {
        { "<leader>uH", "<cmd>lua Snacks.notifier.show_history()<cr>", desc = printf("Show Notifier History"), mode = "n" },
      }
      wk.add(mapping)
    end,
  },
}
