local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- NOTE: lazyvim's extra will be done using LazyExtra. commented here as sometime the lazy extra is disabled by itself?
    -- language specific extras are needed for nvim-dap

    -- Enabled Plugins: (9)
    --   ● coding.blink  blink.cmp  friendly-snippets  blink.compat  catppuccin
    --   ● coding.supermaven  User  noice.nvim  supermaven-nvim
    --   ● dap.dap  User  lua-json5  mason-nvim-dap.nvim  mason.nvim  nvim-dap  nvim-dap-view  nvim-dap-virtual-text
    --   ● editor.neo-tree  neo-tree.nvim
    --   ● editor.snacks_picker    nvim-lspconfig  snacks.nvim  alpha-nvim  dashboard-nvim  flash.nvim  mini.starter  todo-comments.nvim
    --     Fast and modern file picker
    --   ● formatting.prettier  mason.nvim  conform.nvim  none-ls.nvim
    --   ● test.core    neotest  nvim-nio  nvim-dap
    --     Neotest support. Requires language specific adapters to be configured. (see lang extras)
    --   ● util.dot    mason.nvim  nvim-lspconfig  nvim-treesitter
    --     Language support for dotfiles
    --   ● util.mini-hipatterns    mini.hipatterns
    --     Highlight colors in your code. Also includes Tailwind CSS support.

    -- Enabled Languages: (6)
    --   ● lang.deno  User  mason.nvim
    --   ● lang.go  User  go.nvim  goplay.nvim  guihua.lua  mason.nvim  mini.icons  neotest-go  neotest-golang  nvim-dap-go  nvim-lspconfig  nvim-treesitter  vim-go-syntax  which-key.nvim  neotest  none-ls.nvim  nvim-dap
    --   ● lang.markdown  User  bullets.vim  markdown-preview.nvim  mason.nvim  mini.icons  nvim-lspconfig  nvim-toc  nvim-treesitter  render-markdown.nvim  snacks.nvim  telekasten.nvim  telescope.nvim  which-key.nvim  conform.nvim
    --   ● lang.rust  User  neotest-rust  nvim-lspconfig  nvim-treesitter  rust-tools.nvim  which-key.nvim  mason.nvim  neotest
    --   ● lang.typescript    mason.nvim  mini.icons  nvim-lspconfig  nvim-dap
    --   ● lang.zig  neotest-zig  nvim-lspconfig  nvim-treesitter  neotest

    -- import all of my languages config.
    { import = "plugins.extras.lang.go" },
    { import = "plugins.extras.lang.markdown" },
    { import = "plugins.extras.lang.rust" },
    -- { import = "plugins.extras.lang.helm" },
    { import = "plugins.extras.lang.deno" }, -- typescript config is required in LazyExtra
    -- { import = "plugins.extras.lang.json" },
    -- { import = "plugins.extras.lang.php" }, -- WARN: causing lspconfig to load at startup, causing performance issue (50ms delay).
    { import = "plugins.extras.lang.nix" },
    { import = "plugins.extras.lang.hyprland" },

    -- import editor plugins
    -- { import = "plugins.extras.editor.telescope" }, -- uncomment this to use fzf-lua.

    -- import all of my coding plugins.
    { import = "plugins.extras.coding.supermaven" }, --supermaven is a better codeium alternative.

    -- enabled nvim-cmp. uncomment this if uses blink.cmp. make sure to go to option.lua and enable nvim-cmp using global variable.
    -- { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
    -- { import = "plugins.extras.coding.nvim-cmp" },

    -- import dap plugins
    { import = "plugins.extras.dap.dap" },

    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- keymaps = false, -- lazyvim.config.keymaps -- not working?
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true, --  -- WARN: this must be true else fresh install will fail. tried 'Lazy' and manual install but still not working
    -- colorscheme = { "tokyonight", "habamax" }
    -- colorscheme = { "catppuccin" },
  },
  -- ui config
  ui = {
    border = "single",
    size = {
      width = 0.8,
      height = 0.8,
    },
  },
  checker = { enabled = true, notify = false }, -- automatically check for plugin updates
  -- checker = { enabled = false, notify = false }, -- default is false; keep it explicit

  -- change_detection = { enabled = false, notify = false }, -- was true by default

  -- If you don’t use LuaRocks, disable to skip its startup hooks
  -- rocks = { enabled = false },

  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin", -- NOTE: disable this as it is visually buggy when opening nvim with 'nvim .'
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
