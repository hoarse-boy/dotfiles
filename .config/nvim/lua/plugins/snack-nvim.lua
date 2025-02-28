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
        -- lsp picker still shows excluded files. maybe because it is needed as there are lsp references to them.
        exclude = {
          ".git",
          "node_modules",
          "vendor",
          "*.pb.go",
        },

        hidden = true, -- true to shows .files or hidden files
        ignored = true, -- true to shows ignored files. tools like `fd` respects .gitignore and this will make them show up.
        -- args = {} -- NOTE: don't add any args here as this is will overwrite to all sources / pickers

        matcher = {
          frecency = true,
        },

        explorer = {
          -- enable = false,
        },

        -- sources contains all of the pickers table. such as files, grep, todo_comments which are all default sources or pickers.
        -- add new table to create custom pickers.
        -- https://github.com/folke/snacks.nvim/issues/1023
        sources = {
          -- overwrite the default 'files' picker to exclude some files and show hidden files
          files = {
            -- hidden and ignored must be assigned inside sources.files picker as it will not work when enabling in picker only
            hidden = true, -- true to shows .files or hidden files
            ignored = true, -- true to shows ignored files. tools like `fd` respects .gitignore and this will make them show up.
            -- cmd = "fd",
          },

          -- example of creating new custom picker
          -- custom_picker = {}
        },

        debug = {
          scores = true, -- show scores in the list. debugging only
        },
      },

      -- snacks notifier
      -- TODO: add snack-notifier config her

      -- snacks image config at markdown.lua
      -- snacks animate config at animation.lua
    },

    bigfile = {
      enabled = true, -- enable big file detection
      notify = true, -- show notification when big file detected
      size = 1.5 * 1024 * 1024, -- 1.5MB
      line_length = 10000, -- average line length (useful for minified files)
      -- Enable or disable features when big file detected
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.b.minianimate_disable = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },

    keys = {
      -- stylua: ignore start
      { "<leader>.",  function() Snacks.scratch() end, desc = printf("Toggle 'quick-note' Buffer") },

      -- overwriting to make it consistent with other keybinding where the capital letter is for workspace or all files. remove this if lazyvim's default has been changed
      { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = printf"Buffer Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = printf"Diagnostics" },
      -- stylua: ignore end
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
