local my_notes_dir = "~/jho-notes"
local printf = require("plugins.util.printf").printf

-- all snacks.nvim configs goes here
return {
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
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

      -- picker and explorer has the same config. if picker hidden is true, explorer will too.
      picker = {
        cmd = "fd",
        hidden = true, -- explorer will not display files that are gitignored. to open those files, use picker.files.
        -- stylua: ignore start
        args = {
          "--type", "f",          -- Search for files
          "--hidden",             -- Include hidden files and directories
          "--no-ignore",          -- Include files ignored by .gitignore
          "--exclude", ".git",
          "--exclude", "node_modules",
          "--exclude", "vendor",
          "--exclude", "*.pb.go",
        },
        -- stylua: ignore end
        matcher = {
          frecency = true,
        },
        debug = {
          scores = true, -- show scores in the list. debugging only
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
