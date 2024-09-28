local printf = require("plugins.util.printf").printf

return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.defaults.file_ignore_patterns, { "node_modules", "vendor", "proto/*", "**/*.pb.go" }) -- NOTE: ignore folder / files for live grep
      else
        opts.defaults.file_ignore_patterns = { "node_modules", "vendor", "proto/*", "**/*.pb.go" }
      end

      local actions = require("telescope.actions")
      opts.defaults.mappings = {
        i = {
          ["<C-v>"] = actions.nop, -- to disable the default action of <C-v> in telescope which is open v split and change to paste using <C-s-v>
          ["<C-k>"] = actions.cycle_history_next,
          ["<C-j>"] = actions.cycle_history_prev,
          ["<C-f>"] = actions.preview_scrolling_down,
          ["<C-b>"] = actions.preview_scrolling_up,
          ["<esc>"] = actions.close,
        },
        n = {
          ["q"] = actions.close,
          ["<esc>"] = actions.close,
        },
      }
    end,
    keys = {
      -- disable the keymap to grep files. use "sg" instead
      { "<leader>/", false },
      -- { "<leader>xt", false },
      -- { "<leader>xT", false },
      -- change a keymap
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = printf("Find Files") },
      -- add a keymap to browse plugin files. NOTE: this is not needed as the dashboard has handled it.
      -- {
      --   "<leader>fP",
      --   function()
      --     require("telescope.builtin").find_files({
      --       cwd = require("lazy.core.config").options.root,
      --     })
      --   end,
      --   desc = printf"Find Plugin File",
      -- },
    },
  },
}

-- return {
--   {
--     "nvim-telescope/telescope.nvim",
--     dependencies = {
--       "nvim-telescope/telescope-media-files.nvim",
--       "nvim-lua/popup.nvim",
--       "nvim-lua/plenary.nvim"
--     },
--     opts = function(_, opts)
--       if type(opts.ensure_installed) == "table" then
--         vim.list_extend(opts.defaults.file_ignore_patterns, { "node_modules", "vendor", "proto/*", "**/*.pb.go" }) -- NOTE: ignore folder / files for live grep
--       else
--         opts.defaults.file_ignore_patterns = { "node_modules", "vendor", "proto/*", "**/*.pb.go" }
--       end

--       -- extensions = {
--       --     media_files = {
--       --       -- filetypes whitelist
--       --       -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
--       --       filetypes = {"png", "webp", "jpg", "jpeg"},
--       --       -- find command (defaults to `fd`)
--       --       find_cmd = "rg"
--       --     }
--       --   },
--       -- extend table extenstions in opts.
--       -- vim.list_extend(opts.extensions.media_files.filetypes, { "mp4", "webm", "pdf" })
--       -- -- FIX: test.

--       -- if type(opts.extensions) == "table" then
--       --   vim.list_extend(opts.extensions.media_files.filetypes, { "png", "webp", "jpg", "jpeg" })
--       --   vim.list_extend(opts.extensions.media_files.find_command, { "rg" })
--       -- else
--       -- opts.extensions.media_files.filetypes = { "png", "webp", "jpg", "jpeg" }
--       -- opts.extensions.media_files.find_command = { "rg" }

--       opts.extensions = {
--         media_files = {
--           -- filetypes whitelist
--           -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
--           filetypes = { "png", "webp", "jpg", "jpeg" },
--           -- find command (defaults to `fd`)
--           find_cmd = "rg",
--         },
--       }
--       -- end

--       require("telescope").load_extension("media_files")
--     end,

--     keys = {
--       -- disable the keymap to grep files. use "sg" instead
--       { "<leader>/",  false },
--       -- { "<leader>xt", false },
--       -- { "<leader>xT", false },
--       -- change a keymap
--       { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = printf"Find Files" },
--       -- add a keymap to browse plugin files. NOTE: this is not needed as the dashboard has handled it.
--       -- {
--       --   "<leader>fP",
--       --   function()
--       --     require("telescope.builtin").find_files({
--       --       cwd = require("lazy.core.config").options.root,
--       --     })
--       --   end,
--       --   desc = printf"Find Plugin File",
--       -- },
--     },
--   },
-- }
