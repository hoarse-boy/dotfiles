return {
  {
    "folke/noice.nvim",
    -- enabled = false,
    -- WARN: false alarm. disabling noice will not fix the swapfile prompt in notify (cannot be accessed at all as it looks like a simpel notification).
    -- it will still fail when disabling noice as the prompt failed because of a error in nvim.
    -- even when notify shows swapfile prompt and if it has no error, you can still choose the option like usual.

    opts = {
      -- lsp = {
      --   progress = {
      --     enabled = false, -- Disable LSP progress notifications
      --   },
      --   hover = {
      --     enabled = false, -- Disable hover messages
      --   },
      --   signature = {
      --     enabled = false, -- Disable signature help
      --   },
      -- },
      presets = {
        -- you can enable a preset by setting it to true, or a table that will override the preset config
        -- you can also add custom presets that you can enable/disable with enabled=true
        -- bottom_search = false, -- use a classic bottom cmdline for search
        -- command_palette = false, -- position the cmdline and popupmenu together
        -- long_message_to_split = false, -- long messages will be sent to a split
        -- inc_rename = false, -- enables an input dialog for inc-rename.nvim

        -- bottom_search = false,
        -- add border for a better signature lsp popupmenu
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
}
