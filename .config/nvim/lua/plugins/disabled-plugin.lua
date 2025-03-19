-- all disabled lazyvim plugins
return {
  {
    -- uses Comment.nvim instead (much smarter)
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "echasnovski/mini.surround", -- use kylechui/nvim-surround instead, as it has more features.
    enabled = false,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
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
