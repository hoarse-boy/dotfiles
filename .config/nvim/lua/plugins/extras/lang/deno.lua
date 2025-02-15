return {
  -- uses the lazyvim's default typescript config
  -- below is for denols and debugging support
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "js-debug-adapter")
      table.insert(opts.ensure_installed, "deno")
    end,
  },

  -- { -- TODO: find out how to make denols to check all files using lspconfig
  --   "neovim/nvim-lspconfig", 
  --   opts = function()
  --     require("lspconfig").denols.setup({
  --       on_attach = function(client, bufnr)
  --         -- Enable workspace diagnostics
  --         client.server_capabilities.workspaceDiagnostics = true
  --       end, 
  --     })
  --   end,
  -- },
}
