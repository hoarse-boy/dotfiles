-- NOTE: to search '#'' in markdown, use <leader>ss to search using telescope lsp symbol.

local printf = require("plugins.util.printf").printf
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local markdown_keymaps = augroup("markdown_keymaps", {})
local my_notes_dir = "~/jho-notes"
-- local os_util = require("plugins.util.check-os")
-- local os_name = os_util.get_os_name()

-- local enabled = true
-- if vim.g.neovide then
--   enabled = false -- neovide has no kitty image protocol support.
-- end

return {
  {
    "renerocksai/telekasten.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy", -- PERF: this is needed to make telescope lazy-loaded. even though it is inside a dependencies.
        opts = function()
          local actions = require("telescope.actions")

          local open_with_trouble = function(...)
            return require("trouble.sources.telescope").open(...)
          end
          local find_files_no_ignore = function()
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
          end
          local find_files_with_hidden = function()
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            LazyVim.pick("find_files", { hidden = true, default_text = line })()
          end

          return {
            defaults = {
              file_ignore_patterns = { "node_modules", "vendor", "proto/*", "**/*.pb.go" },
              prompt_prefix = " ",
              selection_caret = " ",
              -- open files in the first window that is an actual file.
              -- use the current window if no other window is available.
              get_selection_window = function()
                local wins = vim.api.nvim_list_wins()
                table.insert(wins, 1, vim.api.nvim_get_current_win())
                for _, win in ipairs(wins) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.bo[buf].buftype == "" then
                    return win
                  end
                end
                return 0
              end,
              mappings = {
                i = {
                  ["<c-t>"] = open_with_trouble,
                  ["<a-t>"] = open_with_trouble,
                  ["<a-i>"] = find_files_no_ignore,
                  ["<a-h>"] = find_files_with_hidden,
                  ["<C-Down>"] = actions.cycle_history_next,
                  ["<C-Up>"] = actions.cycle_history_prev,
                  ["<C-f>"] = actions.preview_scrolling_down,
                  ["<C-b>"] = actions.preview_scrolling_up,
                  ["<C-v>"] = actions.nop, -- to disable the default action of <C-v> in telescope which is open v split and change to paste using <C-s-v>
                  ["<C-k>"] = actions.cycle_history_next,
                  ["<C-j>"] = actions.cycle_history_prev,
                  ["<esc>"] = actions.close,
                  ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                  ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
                n = {
                  ["q"] = actions.close,
                  ["<esc>"] = actions.close,
                  ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                  ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
              },
            },
          }
        end,
      },
      -- "nvim-telekasten/calendar-vim", -- NOTE: disabling this. it makes the <leader>ca to be written and cannot be seen in keymaps searching.
    },
    -- enabled = false,
    config = function()
      -- NOTE: naming the file with '-' is preffered but as the function cannot be hooked or updated, it will be as it is.
      -- WARN: all subdirs must not have spaces in their name. especially for images. image.nvim cannot render images with spaces.

      local telekasten = require("telekasten")
      telekasten.setup({
        home = vim.fn.expand(my_notes_dir), -- Put the name of your notes directory here
        -- media_previewer = "telescope-media-files",
        auto_set_filetype = false, -- disabling telekasten.nvim to force markdown to be telekasten filetype.
        image_subdir = "img",
        image_link_style = "markdown",
        filename_space_subst = "-",

        dailies = vim.fn.expand(string.format("%s/daily/", my_notes_dir)), -- path to daily notes

        weeklies = vim.fn.expand(string.format("%s/weekly/", my_notes_dir)), -- path to weekly notes
        weeklies_create_nonexisting = true, -- create non-existing weeklies

        templates = vim.fn.expand(string.format("%s/templates/", my_notes_dir)), -- path to templates
        template_new_note = vim.fn.expand(string.format("%s/templates/new-note-template.md", my_notes_dir)), -- template for new notes
        template_new_daily = vim.fn.expand(string.format("%s/templates/daily-template.md", my_notes_dir)), -- template for new daily notes
        template_new_weekly = vim.fn.expand(string.format("%s/templates/weekly-template.md", my_notes_dir)), -- template for new weekly notes

        subdirs_in_links = true, -- this config is not working. [[dir/title]] is not working when show backlinks.

        -- -- Your other Telekasten configuration options... -- TODO: find out a way to create or update or add hook to the existing function. else create my own.
        -- new_note = function()
        --   -- Replace spaces with hyphens in the note title
        --   local title = vim.fn.input("title: ")
        --   title = title:gsub(" ", "-") -- Replace spaces with hyphens
        --   local filename = title .. ".md" -- Create the filename
        --   telekasten.create_note(filename)
        -- end,
      })
    end,
  },

  {
    -- TODO: check this out https://github.com/kaymmm/bullets.nvim
    -- this plugin auto generate bullets and checkbox toggle
    "hoarse-boy/bullets.vim", -- use my forked version as the original one's fix is yet to be merged
    -- "dkarter/bullets.vim",
    -- enabled = false,
    -- event = "VeryLazy",
    ft = { "markdown", "text", "gitcommit", "scratch" },
    config = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text" }
      vim.g.bullets_outline_levels = { "num", "abc", "std", "-", "+" } -- Custom bullet levels
      vim.g.bullets_enable_in_empty_buffers = 0 -- default = 1
      vim.g.bullets_set_mappings = 0 -- disable default mappings not working on nvim. need to disable the keymaps manually.

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("MyBulletsvimMapping", { clear = true }),
        pattern = "markdown", -- Or specify a filetype like 'markdown' if needed
        callback = function()
          -- remove bullets.vim keymaps. regular nvim del key not working.
          local bufnr = vim.api.nvim_get_current_buf()
          vim.api.nvim_buf_del_keymap(bufnr, "n", "<leader>x") -- Remove toggle checkbox

          -- remove bullets.vim indenting which is buggy. just delete them, as overwriting is not working.
          vim.api.nvim_buf_del_keymap(bufnr, "v", "<")
          vim.api.nvim_buf_del_keymap(bufnr, "v", ">")

          vim.keymap.set("n", "<CR>", "<cmd>pu _<cr>") -- overwrite enter in normal mode to not follow bullets.vim newline indenting

          local wk = require("which-key")
          local markdown_func = require("plugins.util.markdown-func")
          local l_mapping = {
            -- stylua: ignore start

            -- checkbox
            { "gt", function() markdown_func.check_or_add_checkbox(true) end, mode = { "n", "v" }, desc = printf("Add Checkbox and Insert Mode"), buffer = 0 },
            { "gT", function() markdown_func.check_or_add_checkbox() end, mode = { "n", "v" }, desc = printf("Add Checkbox"), buffer = 0 },
            { "gR", function() markdown_func.remove_checkbox() end, mode = { "n", "v" }, desc = printf("Remove Checkbox"), buffer = 0 },
            { "g<space>", "<Plug>(bullets-toggle-checkbox)", mode = "n", desc = printf("Toggle Checkbox"), buffer = 0 }, -- works only in normal mode

            -- separator
            { "gb", function() markdown_func.insert_separator(true) end, desc = printf("Insert '---' and new line with checkbox"), buffer = 0 },
            { "gB", function() markdown_func.insert_separator() end, desc = printf("Insert single '---' and new line"), buffer = 0 },

            -- bullets manipulation
            { "gN", "<Plug>(bullets-renumber)", mode = { "n", "v" }, desc = printf("Renumber Bullets"), buffer = 0 },
            { "<cr>", "<Plug>(bullets-newline)", mode = { "i" }, desc = printf("Bullets Newline in insert mode"), buffer = 0 }, -- NOTE: it conflict with blink
            { "<c-cr>", "<cr>", mode = { "i" }, desc = printf("Normal Newline in insert mode"), buffer = 0 },
            { "o", "<Plug>(bullets-newline)", mode = { "n" }, desc = printf("Newline in normal mode"), buffer = 0 },

            -- WARN: don't enable these. these are bullet.vim default mappings and they are buggy. this is commented as a reminder.
            -- { ">>", "<Plug>(bullets-demote)", mode = { "n" }, desc = printf("Demote Bullet"), buffer = 0 },
            -- { "<<", "<Plug>(bullets-promote)", mode = { "n" }, desc = printf("Promote Bullet"), buffer = 0 },
            -- { ">", "<Plug>(bullets-demote)", mode = { "v" }, desc = printf("Demote Bullet"), buffer = 0 },
            -- { "<", "<Plug>(bullets-promote)", mode = { "v" }, desc = printf("Promote Bullet"), buffer = 0 },

            -- stylua: ignore end
          }

          wk.add(l_mapping)
        end,
      })
    end,
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      local telekasten = require("telekasten")
      local markdown_func = require("plugins.util.markdown-func")
      local tag_manager = require("plugins.util.tag-manager")

      local wk = require("which-key")
      local mapping = {
        -- stylua: ignore start
        { "<leader>n", icon = "󱞁", group = printf("notes"), mode = "n" }, -- group key with prefix like '+'

        -- find notes
        { "<leader>nn", function () Snacks.picker.files({ cwd = my_notes_dir }) end, desc = printf("Find Notes"), mode = "n" }, -- 'n' to match dashboard 'n' to open personal notes. this does not change the global dir.
        { "<leader>ns", function () require("plugins.util.find-files").change_dir_and_live_grep(my_notes_dir) end, desc = printf("Grep Notes (Chane Global Dir)"), mode = "n" },
        -- { "<leader>nn", function() telekasten.find_notes() end, desc = printf("Find Notes"), mode = "n" }, -- telekasten build in func but only uses telescope
        -- { "<leader>ns", function() telekasten.search_notes() end, desc = printf("Search Notes by Keyword"), mode = "n" }, -- telekasten build in func but only uses telescope

        { "<leader>nm", function() markdown_func.search_markdown("#moc", "Find MOC Files") end, desc = printf("Find MOC files"), mode = "n" },
        -- { "<leader>np", function() markdown_func.search_markdown("is_done: false", "Search Pending Work Notes") end, desc = printf("Search pending work notes"), mode = "n" },

        -- open notes
        { "<leader>np", function () require("plugins.util.find-files").open_a_file("personal-todo-moc.md", my_notes_dir) end, desc = printf("Open Personal Todo"), mode = "n" },
        { "<leader>nq", function () require("plugins.util.find-files").open_a_file("quick-note.md", my_notes_dir) end, desc = printf("Open Quick Note"), mode = "n" },
        { "<leader>nC", function() require("plugins.util.find-files").open_a_file("nvim-cheat-sheets.md", my_notes_dir) end, desc = printf("Open Nvim Cheat Sheets"), mode = "n" },

        -- create notes
        { "<leader>nc", function() telekasten.new_note() end, desc = printf("Create new note"), mode = "n" },
        { "<leader>nt", function() telekasten.new_templated_note() end, desc = printf("Create new templated note"), mode = "n" }, -- TODO: request or create PR to have templated notes to have other option of template as params

        -- weekly and daily notes.
        { "<leader>nd", function() telekasten.goto_today() end, desc = printf("Open today note"), mode = "n" }, -- will also create weekly note if not exist
        { "<leader>nw", function() telekasten.goto_thisweek() end, desc = printf("Open weekly note"), mode = "n" }, -- will also create weekly note if not exist

        -- other rarely used note searching
        { "<leader>nF", icon = "󱞁", group = printf("Search Notes"), mode = "n" }, -- group key with prefix like '+'
        { "<leader>nFt", function() telekasten.show_tags() end, desc = printf("Search notes by tag"), mode = "n" },
        { "<leader>nFc", function() markdown_func.search_markdown("is_done: true", "Search Pending Work Notes") end, desc = printf("Search completed work notes"), mode = "n" },
        { "<leader>nFw", function() markdown_func.search_markdown("#work_task", "Search All Work Notes") end, desc = printf("Search All Work Notes"), mode = "n" },

        -- stylua: ignore end
      }
      wk.add(mapping)

      autocmd("Filetype", {
        group = markdown_keymaps,
        pattern = { "md", "markdown" }, -- README.md will have buggy keymaps. find the fix or rename it other than README.md
        callback = function()
          vim.schedule(function()
            -- local util = require("plugins.util.util")

            local l_mapping = {
              -- stylua: ignore start
              { "<leader>l", group = printf("lsp (markdown)"), icon = "󰍔", mode = { "v", "n" }, buffer = 0 },

              -- telekasten navigation. enables lb and ll as oxide is needed. telekasten has some weird behavour, such as copying the name of the backlink when trasversing.
              -- {"gr", function() telekasten.show_backlinks() end,  mode = "n", desc = printf("Show backlinks") },
              -- {"gd", function() telekasten.follow_link() end,  mode = "n", desc = printf("Follow link under cursor") },
              {"<leader>lb", function() telekasten.show_backlinks() end,  mode = "n", desc = printf("Show backlinks"), buffer = 0 },
              {"<leader>ll", function() telekasten.follow_link() end,  mode = "n", desc = printf("Follow link under cursor"), buffer = 0 },
              {"<leader>lL", function() telekasten.insert_link() end, mode = "n", desc = printf("Insert link to note"), buffer = 0 }, -- can open image and link in browser.
              {"<leader>lr", function() telekasten.rename_note() end,  mode = "n", desc = printf("Telekasten Rename Note (and its Backlink)"), buffer = 0 },
              -- {"<leader>lc", function() telekasten.show_calendar() end, mode = "n", desc = printf("Show calendar"), buffer = 0 },

              {"<leader>lv", "<cmd>PasteImage<cr>" , mode = "n", desc = printf("Insert image from clipboard"), buffer = 0 },
              -- set("n", "<leader>lv", function() telekasten.paste_img_and_link() end, buffer = 0, desc = printf("Paste image and create link")) -- use img-clip's
              -- set("n", "<leader>lt", function() telekasten.toggle_todo() end, buffer = 0, desc = printf("Toggle todo")) -- use bullet.vim's

              -- others
              { "<leader>lC", "<cmd>TOC<cr>", desc = printf("Generate Table of Contents"), buffer = 0 },
              { "<leader>ld", function() markdown_func.toggle_is_done_in_buffer() end, desc = printf("Toggle is_done in buffer"), buffer = 0 },
              { "<leader>lp", "<cmd>MarkdownPreviewToggle<cr>", mode = "n", desc = printf("Markdown Preview"), buffer = 0 },
              { "<leader>ld", function() markdown_func.toggle_is_done_in_buffer() end, mode = "n", desc = printf("Toggle is_done in buffer"), buffer = 0 },
              { "<leader>lD", function() telekasten.delete_current_file() end, desc = printf("Delete current file"), buffer = 0 }, -- FIX: not working check linkarsu code
              { "<leader>lI", function() markdown_func.delete_image_file() end, desc = printf("Delete image file"), buffer = 0 }, -- FIX: notworking

              -- tags
              { "<leader>lt", group = printf("tags"), icon = "󰀅 ", mode = "n", desc = printf("Get Tags"), buffer = 0 },
              { "<leader>lts", function() tag_manager.show_tags_picker() end, desc = printf("Show Tags Collection"), buffer = 0 },
              { "<leader>ltf", function() telekasten.show_tags() end, desc = printf("Lsp Show Tags"), buffer = 0 },
              { "<leader>ltc", function() tag_manager.create_new_tags() end, desc = printf("Create a New Tag"), buffer = 0 },
              { "<leader>ltr", function() tag_manager.remove_tags_from_front_matter() end, desc = printf("Remove Tags from Front Matter"), buffer = 0 },
              { "<leader>ltR", function() tag_manager.remove_tags() end, desc = printf("Remove a Tag from Collection"), buffer = 0 },
              { "<leader>lta", function() tag_manager.append_tags_to_front_matter() end, desc = printf("Append Tags to Front Matter"), buffer = 0 },
              { "<leader>ltu", function() tag_manager.rename_tag() end, desc = printf("Rename a Tag"), buffer = 0 },

              -- formatter
              { "<leader>lj", ":!prettier --parser json<CR>",mode = "v", desc = printf("Format JSON code"), buffer = 0 }, -- TODO: find a better one

              -- stylua: ignore end
            }

            wk.add(l_mapping)
          end)
        end,
      })
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- tag = "v7.7.0", -- use this tag as the latest has some bug. it will return an error if resume the nvim session super fast.
    -- event = "VeryLazy",
    ft = "markdown",
    -- enabled = false,
    opts = function(_, opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>uM")

      opts.render_modes = true

      opts.code = {
        enabled = true,
        sign = false,
        style = "full",
        position = "left",
        -- position = "right",
        language_pad = 0,
        disable_background = { "diff" },
        left_margin = 0,
        width = "block",
        min_width = 45,
        left_pad = 2,
        right_pad = 4,
        border = "thin",
        -- above = "█",
        -- below = "█",
        above = "▄",
        below = "▀", -- NOTE: has different color in neovide.
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
      }

      vim.api.nvim_set_hl(0, "RenderMarkdownCode", {
        bg = "#19191a",
      })

      local cust_checkbox_done = "custCheckboxDone"
      opts.checkbox = {
        enabled = true,
        position = "inline",
        -- position = "overlay",
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
          scope_highlight = nil,
        },
        checked = {
          -- icon = "󰱒 ",
          icon = " ",
          highlight = "RenderMarkdownChecked",
          -- scope_highlight = "@markup.strikethrough", -- NOTE: is kinda buggy as the strikethrough pierce through the checkbox to the left side.
          scope_highlight = cust_checkbox_done,
          -- scope_highlight = nil,
        },
        custom = {
          partially_checked = { raw = "[o]", rendered = "󰱒 ", highlight = "RenderMarkdownTodo" },
          partially_checked_2 = { raw = "[.]", rendered = "󰡖 ", highlight = "RenderMarkdownWarn" },
        },
      }

      vim.api.nvim_set_hl(0, cust_checkbox_done, {
        fg = "#4d4b49", -- Foreground color for both terminal and GUI. uses the comments highlight to make it less visible to the unchecked..
        -- cterm = { strikethrough = true }, -- Use a dict with 'strikethrough' key
        -- strikethrough = true, -- For GUI strikethrough
      })

      opts.link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
        custom = {
          web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
          python = { pattern = "%.py$", icon = "󰌠 ", highlight = "RenderMarkdownLink" },
          golang = { pattern = "%.go$", icon = "󰟓 ", highlight = "RenderMarkdownLink" },
          -- TODO: add other filetypes.
          -- rust = { pattern = "%.rs$", icon = "󰠶 ", highlight = "RenderMarkdownLink" },
          -- markdown = { pattern = "%.md$", icon = "󰅯 ", highlight = "RenderMarkdownLink" },
        },
      }

      opts.pipe_table = {
        enabled = true,
        -- preset = "none",
        preset = "round", -- must disable border.
        style = "full",
        cell = "padded",
        min_width = 0,
        -- border = {
        --   "┌",
        --   "┬",
        --   "┐",
        --   "├",
        --   "┼",
        --   "┤",
        --   "└",
        --   "┴",
        --   "┘",
        --   "│",
        --   "─",
        -- },
        alignment_indicator = "━",
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
        filler = "RenderMarkdownTableFill",
      }
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown<cr>", desc = printf("Render Markdown"), mode = "n" },
    },
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        use_absolute_path = false, ---@type boolean
        relative_to_current_file = true, ---@type boolean
        dir_path = "assets", ---@type string | fun(): string
        prompt_for_file_name = false, ---@type boolean -- WARN: this prompt is kinda buggy. will use below function instead.
        file_name = function()
          -- Get the current date and time in the format YYYY-MM-DD-HH-MM-SS
          local date_suffix = os.date("%Y-%m-%d-%H-%M-%S")

          -- Prompt the user for the image name
          local image_name = vim.fn.input("Enter image name (or leave blank for 'image'): ")

          -- If the input is empty, use 'image' as the placeholder
          if image_name == "" then
            image_name = "image"
          else
            -- Replace spaces with '-'
            image_name = image_name:gsub(" ", "-")
          end

          -- Combine the image name with the date suffix
          return image_name .. "-" .. date_suffix
        end,

        -- NOTE: img-clip is very slow but it is very much needed to downsize the image (3 seconds).
        -- it can achieve:
        -- 1,334,554 bytes → 45 KB → ~96.6% smaller (img-clip png convertion. took 1 seconds)
        -- 2,094,203 bytes → 45 KB → ~97.85% smaller (obsidian image pasting. lightning fast)
        -- obsidian image pasting is super fast as it is not converting the image to make it smaller?

        -- convert - -quality 100 avif has no difference in quality
        extension = "avif", ---@type string
        process_cmd = "convert - -quality 75 avif:-", ---@type string

        -- extension = "webp", ---@type string
        -- process_cmd = "convert - -quality 75 webp:-", ---@type string

        -- extension = "png", ---@type string
        -- process_cmd = "convert - -quality 75 png:-", ---@type string

        -- extension = "jpg", ---@type string
        -- process_cmd = "convert - -quality 75 jpg:-", ---@type string

        -- -- Here are other conversion options to play around
        -- -- Notice that with this other option you resize all the images
        -- process_cmd = "convert - -quality 75 -resize 50% png:-", ---@type string

        -- -- These are for jpegs
        -- process_cmd = "convert - -sampling-factor 4:2:0 -strip -interlace JPEG -colorspace RGB -quality 75 jpg:-",
        -- process_cmd = "convert - -strip -interlace Plane -gaussian-blur 0.05 -quality 75 jpg:-",
        --
      },

      -- filetype specific options
      filetypes = {
        markdown = {
          -- encode spaces and special characters in file path
          url_encode_path = true, ---@type boolean

          -- -- The template is what specifies how the alternative text and path
          -- -- of the image will appear in your file
          --
          -- -- $CURSOR will paste the image and place your cursor in that part so
          -- -- you can type the "alternative text", keep in mind that this will
          -- -- not affect the name that the image physically has
          -- template = "![$CURSOR]($FILE_PATH)", ---@type string
          --
          -- -- This will just statically type "Image" in the alternative text
          -- template = "![Image]($FILE_PATH)", ---@type string
          --
          -- -- This will dynamically configure the alternative text to show the
          -- -- same that you configured as the "file_name" above
          template = "![$FILE_NAME](./$FILE_PATH)", ---@type string --  must use ./ to make it work with cmp engine
        },
      },
    },
  },

  -- generate table of contents
  {
    "richardbizik/nvim-toc",
    event = "VeryLazy",
    config = function()
      require("nvim-toc").setup({})
    end,
  },

  -- Ensure mason is installed for easy installation of LSPs
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Install markdown-oxide LSP through Mason
      -- if used markdown-oxide, do not install marksman. it will conflict with markdown-oxide.
      -- such as creating double lsp info.
      vim.list_extend(opts.ensure_installed, { "markdown-oxide", "prettier" })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier" },
      },
    },
  },

  -- Configure nvim-lspconfig to use markdown-oxide
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- NOTE: need at least .git or .obsidian folder to be present in order to properly use markdown-oxide.
      -- it will not become active as single file, which cannot traverse using backlinks if files are not opened.
      -- Use lspconfig's native setup for markdown-oxide
      -- use telekasten.nvim to rename files. oxide has some bug with renaming.

      -- NOTE: capabilities of markdown_oxide:
      -- use <leader>ss to search using telescope lsp symbol powered by oxide lsp. no need for outline.nvim.
      -- can use 'K' to show documentation of the current header and in case of wikilink, it will show the page preview.
      -- use this for now until telekasten traversing has less bug. currently it will copy the name of the backlink when traversing.
      -- also, it will open telescope even when the reference is only one file.
      -- it will also create a new file if it does not exist. it can be turned off though.
      -- this is also usefull for tag traversing which telekasten lacks.
      -- list all available tags when typing `#`.
      -- lsp tags traversing.

      require("lspconfig").markdown_oxide.setup({})
    end,
  },

  -- shows image inside nvim. if this plugin causing memory hogging like 3rd/image.nvim, disable it.
  -- it auto detect imagemagick without using complicated luarocks or lua path like image.nvim.
  -- it can make image showing to be very big.
  -- it shows image super fast.
  -- it does not slows down nvim when quiting when in tmux.
  -- it makes the snacks picker to show images.
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      image = {
        force = false, -- try displaying the image, even if the terminal does not support it
        doc = {
          -- enable image viewer for documents
          -- a treesitter parser must be available for the enabled languages.
          -- supported language injections: markdown, html
          enabled = false, -- manually run `Snacks.image.hover()`
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = false,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          max_width = 200,
          max_height = 150,
        },
        -- window options applied to windows displaying image buffers
        -- an image buffer is a buffer with `filetype=image`
        wo = {
          wrap = false,
          number = false,
          relativenumber = false,
          cursorcolumn = false,
          signcolumn = "no",
          foldcolumn = "0",
          list = false,
          spell = false,
          statuscolumn = "",
        },
        cache = vim.fn.stdpath("cache") .. "/snacks/image",
        env = {},
      },
    },
    keys = {
      { "gk", "<cmd>lua Snacks.image.hover()<cr>", desc = printf("Show image in a floating window"), mode = "n" },
    },
  },
}

-- old config

-- -- incorrect configuration can cause delay when closing nvim. this make nvim in tmux to be super slow and buggy.
-- -- use the `iamcco/markdown-preview.nvim` instead.
-- -- don't remove this code.
-- {
--   "3rd/image.nvim",
--   enabled = false,
--   -- enabled = enabled,
--   -- commit = "5f8fceca2d1be96a45b81de21c2f98bf6084fb34", -- this commits make it a little bit faster.
--   ft = { "markdown" }, -- NOTE: to not make nvim slower when quiting.
--   config = function()
--     -- Set LuaRocks paths dynamically. if set in shell, this code are not needed.
--     -- local home = vim.fn.expand("$HOME")
--     -- package.path = package.path .. ";" .. home .. "/.luarocks/share/lua/5.1/?.lua;" .. home .. "/.luarocks/share/lua/5.1/?/init.lua"
--     -- package.cpath = package.cpath .. ";" .. home .. "/.luarocks/lib/lua/5.1/?.so"

--     -- Verify that magick is loaded correctly
--     local success, _ = pcall(require, "magick")
--     if not success then
--       print("Failed to load magick module. Check Lua paths.")
--     end

--     require("image").setup({
--       backend = "kitty",
--       kitty_method = "normal",
--       integrations = {
--         -- Notice these are the settings for markdown files
--         markdown = {
--           enabled = true,
--           clear_in_insert_mode = false,
--           -- Set this to false if you don't want to render images coming from
--           -- a URL
--           download_remote_images = true,
--           -- Change this if you would only like to render the image where the
--           -- cursor is at
--           -- I set this to true, because if the file has way too many images
--           -- it will be laggy and will take time for the initial load
--           only_render_image_at_cursor = true,
--           -- markdown extensions (ie. quarto) can go here
--           filetypes = { "markdown", "vimwiki" },
--         },
--         html = {
--           enabled = true,
--         },
--         css = {
--           enabled = true,
--         },
--       },
--       max_width = nil,
--       max_height = nil,
--       max_width_window_percentage = nil,

--       -- This is what I changed to make my images look smaller, like a
--       -- thumbnail, the default value is 50
--       -- max_height_window_percentage = 20,
--       max_height_window_percentage = 80,

--       -- toggles images when windows are overlapped
--       window_overlap_clear_enabled = false,
--       window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

--       -- auto show/hide images when the editor gains/looses focus
--       editor_only_render_when_focused = true,

--       -- auto show/hide images in the correct tmux window
--       -- In the tmux.conf add `set -g visual-activity off`
--       tmux_show_only_in_active_window = true,

--       -- render image files as images when opened
--       -- NOTE: wezterm will have buggy webp files in certain cases. it happens when the image's directory is in a complex location.
--       -- in case of current directory of all md files in root and a single image dir, it will not have a problem.
--       -- latest finding, the webp image not working again. use avif instead.
--       hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
--     })
--   end,
-- },

-- Setup completion with nvim-cmp for markdown LSP
-- {
--   "hrsh7th/nvim-cmp",
--   opts = function(_, opts)
--     -- Extend nvim-cmp to support markdown LSP completions
--     -- local cmp = require("cmp")
--     table.insert(opts.sources, {
--       name = "nvim_lsp",
--       option = {
--         markdown_oxide = {
--           keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
--         },
--       },
--     })
--   end,
-- },
