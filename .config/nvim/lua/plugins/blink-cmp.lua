-- old plugin for completion was nvim-cmp

return {
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true, -- this is needed to be true to use current cmp's highlight like 'snippet' color to be red and so on.
        -- vim.cmd.highlight("BlinkCmpKindSnippet guifg=#d42f63") -- make the snippet to have different color like in nvim-cmp
        -- vim.cmd.highlight("BlinkCmpLabel guifg=#ffffff")
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",

      windows = {
        autocomplete = {
          -- draw = "reversed",

          -- Avoid directly inserting on enter
          selection = "auto_insert",

          -- Similar to nvim cmp visually
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
          },

          winblend = 0,
          border = "rounded",
          winhighlight = "Normal:NormalFloat",
          -- winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          auto_show = true,
        },
        ghost_text = {
          -- enabled = vim.g.ai_cmp,
        },
      },

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } },

      --  This one is not mandatory but I think it's a good idea to use the same snippet provider so you use the same
      --  keybindings regardless of how was the snippet expanded
      -- accept = {
      --   expand_snippet = require("luasnip").lsp_expand,
      -- },

      -- experimental signature help support
      -- trigger = { signature_help = { enabled = true } }
      trigger = { signature_help = { enabled = false } }, -- NOTE: signature for snippets? false still gives double signature in lua lsp only.
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        completion = {
          -- remember to enable your providers here
          -- enabled_providers = { "luasnip", "lsp", "path", "snippets", "buffer" },
          -- enabled_providers = { "lsp", "path", "snippets", "buffer" },
          enabled_providers = { "lsp", "path", "buffer" },
        },
      },

      keymap = {
        preset = "enter",
        -- NOTE: uses lazyvim extra for supermaven which disabled accept binding and use this instead.
        -- this is not needed as my supermaven config is working.
        -- ["<c-a>"] = {
        --   LazyVim.cmp.map({ "ai_accept" }),
        --   "fallback",
        -- },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
    },

    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.completion.enabled_providers
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend("force", { name = source, module = "blink.compat.source" }, opts.sources.providers[source] or {})
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end
      require("blink.cmp").setup(opts)
    end,
  },

  -- add icons
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.kind_icons = LazyVim.config.icons.kinds
    end,
  },

  -- lazydev
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        completion = {
          -- add lazydev to your completion providers
          enabled_providers = { "lazydev" },
        },
        providers = {
          lsp = {
            -- dont show LuaLS require statements when lazydev has items
            fallback_for = { "lazydev" },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
          },
        },
      },
    },
  },

  -- add provider for luasnip
  -- NOTE: this is needed for luasnip snippets to be expanded when using blink.cmp without returning error.
  {
    "saghen/blink.cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "leiserfg/blink_luasnip",
    },
    opts = {
      accept = {
        expand_snippet = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        auto_brackets = {
          enabled = true,
        },
      },

      sources = {
        completion = {
          enabled_providers = { "luasnip" },
          -- enabled_providers = { "lsp", "path", "luasnip", "buffer" },
        },

        providers = {
          luasnip = {
            name = "luasnip",
            module = "blink_luasnip",
            score_offset = 1, -- to make the snippet to be positioned higher.
            opts = {
              use_show_condition = false, -- disables filtering completion candidates
              show_autosnippets = true,
            },
          },
        },
      },
    },
  },

  -- catppuccin support
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },

  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   dependencies = {
  --     { "saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
  --     { "saadparwaiz1/cmp_luasnip" },
  --   },
  --   opts = {
  --     sources = { compat = { "luasnip" } },
  --     snippets = {
  --       expand = function(snippet)
  --         require("luasnip").lsp_expand(snippet)
  --       end,
  --       active = function(filter)
  --         if filter and filter.direction then
  --           return require("luasnip").jumpable(filter.direction)
  --         end
  --         return require("luasnip").in_snippet()
  --       end,
  --       jump = function(direction)
  --         require("luasnip").jump(direction)
  --       end,
  --     },
  --   },
  -- },
}
