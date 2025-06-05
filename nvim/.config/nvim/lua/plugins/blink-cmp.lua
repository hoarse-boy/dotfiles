-- NOTE: Specify the trigger character(s) used for luasnip
local trigger_text = ";"
local printf = require("plugins.util.printf").printf

vim.cmd.highlight("BlinkCmpLabelMatch guifg=#8f6e6e") -- to make the fuzzy match more visible as some cmp suggestion has identical white highlight too

return {
  {
    "saghen/blink.cmp",
    -- version = not vim.g.lazyvim_blink_main and "*",
    -- tag = "v0.11.0", -- currently working version. follow lazyvim versioning later.
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    opts = {
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
      },

      sources = {
        -- commenting this out since it is not working in version 0.12
        -- default = { "lsp", "path", "buffer" },

        providers = {
          -- lsp = {},
          -- lazydev = {
          --   name = "LazyDev",
          --   module = "lazydev.integrations.blink",
          --   fallbacks = { "lsp" },
          -- },

          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 25,
            -- When typing a path, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no path
            -- suggestions
            fallbacks = { "snippets", "buffer" },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },

          -- NOTE: this also fix the issue of double snippets
          snippets = {
            name = "snippets",
            enabled = true,
            -- max_items = 8,
            min_keyword_length = 2,
            module = "blink.cmp.sources.snippets",
            score_offset = 85, -- the higher the number, the higher the priority

            --   -- NOTE: disable snippet trigger as it is buggy
            --   -- Only show snippets if I type the trigger_text characters, so
            --   -- to expand the "bash" snippet, if the trigger_text is ";" I have to
            --   should_show_items = function()
            --     local col = vim.api.nvim_win_get_cursor(0)[2]
            --     local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            --     -- NOTE: remember that `trigger_text` is modified at the top of the file
            --     return before_cursor:match(trigger_text .. "%w*$") ~= nil
            --   end,
            --   -- After accepting the completion, delete the trigger_text characters
            --   -- from the final inserted text
            --   transform_items = function(_, items)
            --     local col = vim.api.nvim_win_get_cursor(0)[2]
            --     local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            --     local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
            --     if trigger_pos then
            --       for _, item in ipairs(items) do
            --         item.textEdit = {
            --           newText = item.insertText or item.label,
            --           range = {
            --             start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
            --             ["end"] = { line = vim.fn.line(".") - 1, character = col },
            --           },
            --         }
            --       end
            --     end
            --     -- NOTE: After the transformation, I have to reload the luasnip source
            --     -- Otherwise really crazy shit happens and I spent way too much time
            --     -- figurig this out
            --     vim.schedule(function()
            --       require("blink.cmp").reload("snippets")
            --     end)
            --     return items
            --   end,

            -- stylua: ignore
          },
        },
      },
      -- New completion window configuration
      completion = {
        menu = { border = "single", winblend = 0, winhighlight = "Normal:NormalFloat" },
        documentation = {
          window = {
            border = "single",
            winblend = 0,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
        },
      },
      -- New signature window configuration
      signature = { window = { border = "single" } },
      keymap = {
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-y>"] = { "select_and_accept" }, -- Accept the current suggestion
        ["<CR>"] = { "fallback" }, -- NOTE: Prevents auto-selecting a suggestion. this is done to avoid choosing suggestion instead of bullets.vim enter binding
      },
    },
    -- config = function(_, opts)
    --   -- Merge any external compatibility sources (if provided) into `sources.default`
    --   for _, source in ipairs(opts.sources.compat or {}) do
    --     opts.sources.providers[source] = vim.tbl_deep_extend("force", { name = source, module = "blink.compat.source" }, opts.sources.providers[source] or {})
    --     if type(opts.sources.default) == "table" and not vim.tbl_contains(opts.sources.default, source) then
    --       table.insert(opts.sources.default, source)
    --     end
    --   end
    --   -- Remove the unsupported field.
    --   opts.sources.compat = nil

    --   -- Remove any unwanted fallback field from the 'lsp' provider.
    --   if opts.sources.providers.lsp and opts.sources.providers.lsp.fallback then
    --     opts.sources.providers.lsp.fallback = nil
    --   end

    --   require("blink.cmp").setup(opts)
    -- end,
  },

  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    keys = {
      {
        "<C-G>",
        function()
          local ok, luasnip = pcall(require, "luasnip")
          if ok and luasnip.jumpable() then
            luasnip.jump(-1)
          end
        end,
        desc = printf("Jump to previous placeholder (LuaSnip)"),
        noremap = true,
        silent = true,
        mode = { "v", "i" },
      },
      {
        "<C-H>",
        function()
          local ok, luasnip = pcall(require, "luasnip")
          if ok and luasnip.jumpable() then
            luasnip.jump(1)
          end
        end,
        desc = printf("Jump to next placeholder (LuaSnip)"),
        noremap = true,
        silent = true,
        mode = { "v", "i" },
      },
    },
  },

  -- make supermaven to not be lazy-loaded to make the highligther work
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   event = "VeryLazy",
  --   dependencies = { "saghen/blink.cmp" },
  --   opts = {
  --     -- Add SuperMaven options here
  --   },
  -- },

  {
    "catppuccin",
    optional = true,
    opts = { integrations = { blink_cmp = true } },
  },
}
