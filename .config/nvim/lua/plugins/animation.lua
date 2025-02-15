return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
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
}
