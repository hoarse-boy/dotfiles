-- this plugins makes editing chezmoi dotfiles faster and easier

-- TODO: it is kinda slow when saving and auto chezmoi add. turn off auto chezmoi add?

return {
  {
    "xvzc/chezmoi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- automatically apply changes on files under chezmoi source path
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function(ev)
          local bufnr = ev.buf
          local edit_watch = function()
            require("chezmoi.commands.__edit").watch(bufnr)
          end
          vim.schedule(edit_watch)
        end,
      })

      require("chezmoi").setup({
        edit = {
          watch = false,
          force = false,
        },
        notification = {
          on_open = true,
          on_apply = true,
          on_watch = false,
        },
        telescope = {
          select = { "<CR>" },
        },
      })
    end,
  },
}
