-- TODO: remove this and use snacks's notify

return {
  {
    "folke/which-key.nvim", -- TODO: move this to snacks notifier
    opts = function(_, _)
      local wk = require("which-key")
      local printf = require("plugins.util.printf").printf
      local mapping = {
        { "<leader>uH", "<cmd>lua Snacks.notifier.show_history()<cr>", desc = printf("Show Notifier History"), mode = "n" },
      }
      wk.add(mapping)
    end,
  },
}

-- return {
--   "rcarriga/nvim-notify",
--   -- NOTE: requiring notify to any other file will result in notify or any lua plugin to use the default.
--   enabled = false,
--   keys = {
--     {
--       "<leader>uH",
--       function()
--         require("telescope").extensions.notify.notify()
--       end,
--       desc = printf("Open Notify History"),
--     },
--   },
--   opts = function(_, _)
--     local default_notify = vim.notify
--  -- FIX:
--     vim.notify = function(msg, ...)
--       -- Check if the message is related to swap files
--       if msg:match("ATTENTION") or msg:match("swap") then
--         -- Use the default Neovim notification for swapfile messages
--         return default_notify(msg, vim.log.levels.WARN)
--       end
--       -- Otherwise, use the notify.nvim for other messages
--       return require("notify")(msg, ...)
--     end
--   end,
-- }
