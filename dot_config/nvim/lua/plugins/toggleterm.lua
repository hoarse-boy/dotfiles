-- this code is obsolete as snacks.nvim terminal is very easy to configure and does not need complicated autocmd to make it fast.

return {
  -- {
  --   "akinsho/toggleterm.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     local Terminal = require("toggleterm.terminal").Terminal
  --     local task_tui

  --     local function create_task_tui()
  --       task_tui = Terminal:new({
  --         cmd = "taskwarrior-tui",
  --         hidden = true,
  --         direction = "float",
  --         float_opts = {
  --           border = "curved",
  --           width = 150,
  --           height = 100,
  --         },
  --       })
  --     end

  --     -- Initialize the terminal
  --     create_task_tui()

  --     -- Function to toggle Taskwarrior-TUI
  --     function _toggle_task_tui()
  --       task_tui:toggle()
  --     end

  --     vim.api.nvim_create_autocmd("VimEnter", {
  --       callback = function()
  --         task_tui:spawn() -- Pre-create the terminal so it opens instantly later
  --       end,
  --     })

  --     -- Recreate the terminal when it closes
  --     vim.api.nvim_create_autocmd("TermClose", {
  --       pattern = "*",
  --       callback = function()
  --         vim.defer_fn(function()
  --           task_tui:spawn() -- Pre-create the terminal so it opens instantly later
  --         end, 100) -- Delay slightly to avoid errors
  --       end,
  --     })
  --   end,

  --   config = function()
  --     require("toggleterm").setup({
  --       size = 45,
  --       open_mapping = [[<c-\>]],
  --       shade_terminals = true,
  --       direction = "float",
  --       float_opts = {
  --         border = "curved",
  --       },
  --     })
  --   end,
  --   keys = {
  --     -- {
  --     --   "<leader>T",
  --     --   function()
  --     --     toggle_task_tui()
  --     --   end,
  --     --   desc = "Taskwarrior TUI",
  --     -- },
  --   },
  -- },
}
