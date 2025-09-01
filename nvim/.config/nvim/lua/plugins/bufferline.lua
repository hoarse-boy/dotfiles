local is_bigfile = require("plugins.util.check-for-bigfile").is_bigfile

return {
  {
    "akinsho/bufferline.nvim",
    enabled = false, -- FIX: . disable for now as the transparency is broken in nvim 0.11

    -- enabled = function()
    --   return not is_bigfile()
    -- end,

    opts = function(_, opts)
      opts.options = {
        diagnostics = "nvim_lsp",
        indicator = {
          icon = "", -- this should be omitted if indicator style is not 'icon'
          -- style = "none",
          style = "underline", -- "icon" | "underline" | "none", -- NOTE: underline is broken in tmux. somehow it is working in tmux. tested on mac for now.
        },

        highlights = { -- FIX: . not working. broken in nvim 0.11?
          fill = {
            -- fg = "NONE",
            bg = "NONE",
          },
          background = {
            -- fg = "NONE",
            bg = "NONE",
          },
          tab = {
            -- fg = "NONE",
            bg = "NONE",
          },
          tab_selected = {
            -- fg = "NONE",
            bg = "NONE",
          },
          tab_separator = {
            -- fg = "NONE",
            bg = "NONE",
          },
          tab_separator_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            underline = "NONE",
          },
          tab_close = {
            -- fg = "NONE",
            bg = "NONE",
          },
          close_button = {
            -- fg = "NONE",
            bg = "NONE",
          },
          close_button_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          close_button_selected = {
            -- fg = "NONE",
            bg = "NONE",
          },
          buffer_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          buffer_selected = {
            -- fg = "NONE",
            bg = "NONE",
            bold = true,
            italic = true,
          },
          numbers = {
            -- fg = "NONE",
            bg = "NONE",
          },
          numbers_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          numbers_selected = {
            -- fg = "NONE",
            bg = "NONE",
            bold = true,
            italic = true,
          },
          diagnostic = {
            -- fg = "NONE",
            bg = "NONE",
          },
          diagnostic_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          diagnostic_selected = {
            -- fg = "NONE",
            bg = "NONE",
            bold = true,
            italic = true,
          },
          hint = {
            -- fg = "NONE",
            sp = "NONE",
            bg = "NONE",
          },
          hint_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          hint_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          hint_diagnostic = {
            -- fg = "NONE",
            sp = "NONE",
            bg = "NONE",
          },
          hint_diagnostic_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          hint_diagnostic_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          info = {
            -- fg = "NONE",
            sp = "NONE",
            bg = "NONE",
          },
          info_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          info_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          info_diagnostic = {
            -- fg = "NONE",
            sp = "NONE",
            bg = "NONE",
          },
          info_diagnostic_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          info_diagnostic_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          warning = {
            -- fg = "NONE",
            sp = "NONE",
            bg = "NONE",
          },
          warning_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          warning_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          warning_diagnostic = {
            -- fg = "NONE",
            sp = "NONE",
            bg = "NONE",
          },
          warning_diagnostic_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          warning_diagnostic_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          error = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
          },
          error_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          error_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          error_diagnostic = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
          },
          error_diagnostic_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          error_diagnostic_selected = {
            -- fg = "NONE",
            bg = "NONE",
            sp = "NONE",
            bold = true,
            italic = true,
          },
          modified = {
            -- fg = "NONE",
            bg = "NONE",
          },
          modified_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          modified_selected = {
            -- fg = "NONE",
            bg = "NONE",
          },
          duplicate_selected = {
            -- fg = "NONE",
            bg = "NONE",
            italic = true,
          },
          duplicate_visible = {
            -- fg = "NONE",
            bg = "NONE",
            italic = true,
          },
          duplicate = {
            -- fg = "NONE",
            bg = "NONE",
            italic = true,
          },
          separator_selected = {
            -- fg = "NONE",
            bg = "NONE",
          },
          separator_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          separator = {
            -- fg = "NONE",
            bg = "NONE",
          },
          indicator_visible = {
            -- fg = "NONE",
            bg = "NONE",
          },
          indicator_selected = {
            -- fg = "NONE",
            bg = "NONE",
          },
          pick_selected = {
            -- fg = "NONE",
            bg = "NONE",
            bold = true,
            italic = true,
          },
          pick_visible = {
            -- fg = "NONE",
            bg = "NONE",
            bold = true,
            italic = true,
          },
          pick = {
            -- fg = "NONE",
            bg = "NONE",
            bold = true,
            italic = true,
          },
          offset_separator = {
            -- fg = "NONE",
            bg = "NONE",
          },
          trunc_marker = {
            -- fg = "NONE",
            bg = "NONE",
          },
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
