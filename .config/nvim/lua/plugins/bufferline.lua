return {
  {
    "akinsho/bufferline.nvim",
    -- enabled = false,
    opts = function(_, opts)
      opts.options = {
        diagnostics = "nvim_lsp",
        indicator = {
          icon = "", -- this should be omitted if indicator style is not 'icon'
          -- style = "none",
          style = "underline", -- "icon" | "underline" | "none", -- NOTE: underline is broken in tmux. somehow it is working in tmux. tested on mac for now.
        },

        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },

        always_show_bufferline = false, -- NOTE: to fix snacks dashboard showing empty buffer when first opening nvim.
        show_buffer_close_icons = false,
        show_close_icon = true,
        -- hover = {
        --   enabled = true,
        --   delay = 200,
        --   reveal = { "close" },
        -- },
        separator_style = { "", "" }, -- use this to remove the buggy lazyvim separator. ex. "slant" | "slope" | "thick" | "thin" | { "any", "any" }
      }

      require("bufferline").setup(opts)
    end,
  },

  -- {
  --   "akinsho/bufferline.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
  --     { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
  --     { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
  --     { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
  --     { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
  --     { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  --     { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
  --     { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  --     { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
  --     { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  --   },
  --   opts = {
  --     options = {
  --       -- stylua: ignore
  --       close_command = function(n) Snacks.bufdelete(n) end,
  --       -- stylua: ignore
  --       right_mouse_command = function(n) Snacks.bufdelete(n) end,
  --       diagnostics = "nvim_lsp",
  --       always_show_bufferline = false,
  --       diagnostics_indicator = function(_, _, diag)
  --         local icons = LazyVim.config.icons.diagnostics
  --         local ret = (diag.error and icons.Error .. diag.error .. " " or "")
  --           .. (diag.warning and icons.Warn .. diag.warning or "")
  --         return vim.trim(ret)
  --       end,
  --       offsets = {
  --         {
  --           filetype = "neo-tree",
  --           text = "Neo-tree",
  --           highlight = "Directory",
  --           text_align = "left",
  --         },
  --       },
  --       ---@param opts bufferline.IconFetcherOpts
  --       get_element_icon = function(opts)
  --         return LazyVim.config.icons.ft[opts.filetype]
  --       end,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("bufferline").setup(opts)
  --     -- Fix bufferline when restoring a session
  --     vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
  --       callback = function()
  --         vim.schedule(function()
  --           pcall(nvim_bufferline)
  --         end)
  --       end,
  --     })
  --   end,
  -- },
}
