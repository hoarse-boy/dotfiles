-- to change the keymaps of lspconfig use init (https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps)
-- NOTE: only for lspconfig, will define the keymaps here, else will be in lua.config.keymaps folder

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 1. Add custom keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gl",
        vim.diagnostic.open_float,
        desc = "Line Diagnostics",
      }

      -- 2. Change diagnostics config
      vim.diagnostic.config({
        float = { border = "rounded" },
      })
    end,
  },
}
