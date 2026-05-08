-- to change the keymaps of lspconfig use init (https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps)
-- NOTE: only for lspconfig, will define the keymaps here, else will be in lua.config.keymaps folder

return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     -- 1. Add custom keymaps
  --     local keys = require("lazyvim.plugins.lsp.keymaps").get()
  --     keys[#keys + 1] = {
  --       "gl",
  --       vim.diagnostic.open_float,
  --       desc = "Line Diagnostics",
  --     }

  --     -- 2. Change diagnostics config
  --     vim.diagnostic.config({
  --       float = { border = "rounded" },
  --     })
  --   end,
  -- }, -- FIX: . check and test this. remove comments later:

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}

      -- Initialize keys as an empty table if it doesn't exist
      opts.servers["*"].keys = opts.servers["*"].keys or {}

      -- Extend the existing table instead of overwriting it
      vim.list_extend(opts.servers["*"].keys, {
        {
          "gl",
          vim.diagnostic.open_float,
          desc = "Line Diagnostics",
        },
      })

      -- Diagnostics config
      vim.diagnostic.config({
        float = { border = "rounded" },
      })
    end,
  },
}
