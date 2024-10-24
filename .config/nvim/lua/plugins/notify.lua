local printf = require("plugins.util.printf").printf

return {
  "rcarriga/nvim-notify",
  -- NOTE: requiring notify to any other file will result in notify or any lua plugin to use the default.
  keys = {
    {
      "<leader>uH",
      function()
        require("telescope").extensions.notify.notify()
      end,
      desc = printf("Open Notify History"),
    },
  },
  opts = function(_, _)
    local default_notify = vim.notify
 -- FIX: 
    vim.notify = function(msg, ...)
      -- Check if the message is related to swap files
      if msg:match("ATTENTION") or msg:match("swap") then
        -- Use the default Neovim notification for swapfile messages
        return default_notify(msg, vim.log.levels.WARN)
      end
      -- Otherwise, use the notify.nvim for other messages
      return require("notify")(msg, ...)
    end
  end,
}
