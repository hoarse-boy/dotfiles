-- return {
--   { require("plugins.themes.catppuccin") },
--   -- { require("plugins.themes.tokyo-night") },
--   -- { require("plugins.themes.kanagawa") },
--   -- { require("plugins.themes.starry") },
--   -- { require("plugins.themes.aurora") },
--   -- { require("plugins.themes.nightfox") },
--   -- { require("plugins.themes.vscode") },

--   -- Configure LazyVim to load a theme
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "catppuccin", -- default theme
--       -- colorscheme = "kanagawa",
--       -- colorscheme = "vscode",
--       -- colorscheme = "mariana",
--       --Earlysummer
--       -- colorscheme = "aurora",
--       -- colorscheme = "kanagawa-lotus",

--       -- colorscheme = "tokyonight",
--       -- colorscheme = "nightfox",
--     },
--   },
-- }

return {
  -- require("plugins.themes.catppuccin"),
  require("plugins.themes.tokyo-night"),
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin", -- default theme
      colorscheme = "tokyonight",
    },
  },
}
