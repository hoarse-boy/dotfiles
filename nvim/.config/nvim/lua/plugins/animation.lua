local enableCursor = true
local enabledAnimation = true
if vim.g.neovide then
  enabledAnimation = false
end

local is_kitty = require("plugins.util.util").get_terminal() == "kitty"
if is_kitty then
  enableCursor = false -- kitty has mouse tralinign animation like neovide
end

local is_bigfile = require("plugins.util.check-for-bigfile").is_bigfile

return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        -- enabled = enabledAnimation,
        enabled = not is_bigfile(),

        animate = {
          duration = { step = 6, total = 100 },
          -- duration = { step = 15, total = 250 }, -- default. higher total value will makes `g` or `G` to be slower even with lower step value.
          easing = "linear",
        },
        -- what buffers to animate
        -- filter = function(buf) -- NOTE: this makes the bullet.vim to have errors as it tries to delete mapping that doesn't exist
        --   return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
        -- end,
      },
    },
  },

  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    -- enabled = enableCursor,
    enabled = false, -- disabled, as both kitty and ghostty can do cursor trail animation.
    opts = {
      -- -- fire animation when moving cursor
      -- cursor_color = "#ff8800",
      -- stiffness = 0.3,
      -- trailing_stiffness = 0.1,
      -- trailing_exponent = 5,
      -- hide_target_hack = true,
      -- gamma = 1,

      -- faster animation
      stiffness = 0.8, -- 0.6
      trailing_stiffness = 0.2, -- 0.3
      distance_stop_animating = 0.5, -- 0.1

      -- Smear cursor color. Defaults to Cursor GUI color if not set.
      -- Set to "none" to match the text color at the target cursor position.
      cursor_color = "#279bc2",
      -- cursor_color = "#d3cdc3",

      -- Smear cursor when switching buffers or windows.
      smear_between_buffers = true,

      -- Smear cursor when moving within line or to neighbor lines.
      -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
      smear_between_neighbor_lines = true,

      -- Draw the smear in buffer space instead of screen space when scrolling
      scroll_buffer_space = true,

      -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
      -- Smears will blend better on all backgrounds.
      legacy_computing_symbols_support = true,
      transparent_bg_fallback_color = "#303030",

      -- hide_target_hack = true,
      -- Smear cursor in insert mode.
      -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
      smear_insert_mode = true,
    },
  },
}
