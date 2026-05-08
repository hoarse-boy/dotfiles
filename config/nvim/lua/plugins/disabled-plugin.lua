-- all disabled lazyvim plugins
return {
  {
    -- uses Comment.nvim instead (much smarter)
    "nvim-mini/mini.comment",
    enabled = false,
  },
  {
    "nvim-mini/mini.surround", -- use kylechui/nvim-surround instead, as it has more features.
    enabled = false,
  },
  {
    "ibhagwan/fzf-lua",
    enabled = false,
  },
  {
    "nvim-mini/mini.animate",
    enabled = false, -- disabled plugin
  },
}

-- NOTE: all of my old or unused plugins

-- NOTE: ident-blankline v3 is now better.
-- local char_symbol = "▏"
-- return {
--   "nvimdev/indentmini.nvim",
--   enabled = false, -- disabled plugin
--   event = "LazyFile",
--   config = function()
--     -- Colors are applied automatically based on user-defined highlight groups.
--     -- There is no default value.
--     -- vim.cmd.highlight("IndentLine guifg=#323b4a")
--     vim.cmd.highlight("IndentLine guifg=#4d4b49")
--     -- Current indent line highlight
--     vim.cmd.highlight("IndentLineCurrent guifg=#87b7c7")

--     require("indentmini").setup({
--       char = char_symbol,
--     })
--   end,
-- }
