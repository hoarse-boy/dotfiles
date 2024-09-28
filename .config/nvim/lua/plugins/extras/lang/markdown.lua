local printf = require("plugins.util.printf").printf
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local markdown_keymaps = augroup("markdown_keymaps", {})

local os_util = require("plugins.util.check-os")
local os_name = os_util.get_os_name()


-- -- FIX: 
-- local function toggle_checkbox_and_date()
--   -- Get the current date in the desired format
--   local date = os.date("%Y-%m-%d")

--   -- Define the symbol and date string
--   local symbol_and_date = "✅ " .. date

--   -- Get the current line content
--   local line = vim.api.nvim_get_current_line()

--   -- Check if the line has a checkbox
--   local checkbox_pattern = "^(%s*)%- %[ %]"
--   local checked_pattern = "^(%s*)%- %[x%]"

--   if string.match(line, checkbox_pattern) then
--     -- Replace '- [ ]' with '- [x]' and append the symbol and date
--     local new_line = line:gsub(checkbox_pattern, "%1- [x]") .. " " .. symbol_and_date
--     vim.api.nvim_set_current_line(new_line)
--   elseif string.match(line, checked_pattern) then
--     -- Replace '- [x]' with '- [ ]' and remove the symbol and date
--     local new_line = line:gsub(checked_pattern, "%1- [ ]"):gsub(" ✅ %d%d%d%d%-%d%d%-%d%d$", "")
--     vim.api.nvim_set_current_line(new_line)
--   elseif line:match("^%s*$") then
--     -- If the line is empty or only contains whitespace, add '- [ ] ' and place the cursor at the correct position
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] "
--     vim.api.nvim_set_current_line(new_line)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>A", true, false, true), "n", true)
--   else
--     -- Prepend '- [ ]' to the line if it doesn't have a checkbox
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] " .. line:sub(#indent + 1)
--     vim.api.nvim_set_current_line(new_line)
--   end
-- end

-- -- FIX: better.
-- local function toggle_checkbox_and_date()
--   -- Get the current date in the desired format
--   local date = os.date("%Y-%m-%d")

--   -- Define the symbol and date string
--   local symbol_and_date = "✅ " .. date

--   -- Get the current line content
--   local line = vim.api.nvim_get_current_line()

--   -- Check if the line has an unchecked checkbox or a partially checked checkbox
--   local checkbox_pattern = "^(%s*)%- %[ %]"  -- Pattern for unchecked checkbox
--   local partially_checked_pattern = "^(%s*)%- %[o%]"  -- Pattern for partially checked checkbox
--   local checked_pattern = "^(%s*)%- %[x%]"  -- Pattern for checked checkbox

--   if string.match(line, checkbox_pattern) then
--     -- Replace '- [ ]' with '- [x]' and append the symbol and date
--     local new_line = line:gsub(checkbox_pattern, "%1- [x]") .. " " .. symbol_and_date
--     vim.api.nvim_set_current_line(new_line)
--   elseif string.match(line, partially_checked_pattern) then
--     -- Replace '- [o]' with '- [x]' and append the symbol and date
--     local new_line = line:gsub(partially_checked_pattern, "%1- [x]") .. " " .. symbol_and_date
--     vim.api.nvim_set_current_line(new_line)
--   elseif string.match(line, checked_pattern) then
--     -- Replace '- [x]' with '- [ ]' and remove the symbol and date
--     local new_line = line:gsub(checked_pattern, "%1- [ ]"):gsub(" ✅ %d%d%d%d%-%d%d%-%d%d$", "")
--     vim.api.nvim_set_current_line(new_line)
--   elseif line:match("^%s*$") then
--     -- If the line is empty or only contains whitespace, add '- [ ] ' and place the cursor at the correct position
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] "
--     vim.api.nvim_set_current_line(new_line)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>A", true, false, true), "n", true)
--   else
--     -- Prepend '- [ ]' to the line if it doesn't have a checkbox
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] " .. line:sub(#indent + 1)
--     vim.api.nvim_set_current_line(new_line)
--   end
-- end

-- -- FIX: 
-- local function toggle_checkbox_and_date()
--   -- Get the current date in the desired format
--   local date = os.date("%Y-%m-%d")

--   -- Define the symbol and date string
--   local symbol_and_date = "✅ " .. date

--   -- Get the current line content
--   local line = vim.api.nvim_get_current_line()

--   -- Check if the line has an unchecked checkbox, a partially checked checkbox, or a checked checkbox
--   local checkbox_pattern = "^(%s*)%- %[ %]"  -- Pattern for unchecked checkbox
--   local partially_checked_pattern = "^(%s*)%- %[o%]"  -- Pattern for partially checked checkbox
--   local checked_pattern = "^(%s*)%- %[x%]"  -- Pattern for checked checkbox

--   if string.match(line, checkbox_pattern) then
--     -- Replace '- [ ]' with '- [x]' and append the symbol and date
--     local new_line = line:gsub(checkbox_pattern, "%1- [x]") .. " " .. symbol_and_date
--     vim.api.nvim_set_current_line(new_line)
--   elseif string.match(line, partially_checked_pattern) then
--     -- Replace '- [o]' with '- [x]' and append the symbol and date
--     local new_line = line:gsub(partially_checked_pattern, "%1- [x]") .. " " .. symbol_and_date
--     vim.api.nvim_set_current_line(new_line)
--   elseif string.match(line, checked_pattern) then
--     -- If the line has a checked checkbox, do nothing; bullets.vim will handle it.
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(bullets-toggle-checkbox)", true, false, true), "n", true)
--     return -- Exit to prevent further modifications
--   elseif line:match("^%s*$") then
--     -- If the line is empty or only contains whitespace, add '- [ ] ' and place the cursor at the correct position
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] "
--     vim.api.nvim_set_current_line(new_line)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>A", true, false, true), "n", true)
--   else
--     -- Prepend '- [ ]' to the line if it doesn't have a checkbox
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] " .. line:sub(#indent + 1)
--     vim.api.nvim_set_current_line(new_line)
--   end
-- end


-- FIX: move this to utils.lua?
local function delete_current_file()
  local current_file = vim.fn.expand("%:p")
  if current_file and current_file ~= "" then
    -- Check for trash utility depending on OS
    local trash_cmd = nil

    if os_name == os_util.LINUX then
      -- Check if trashy is installed on Linux
      if vim.fn.executable("trashy") == 0 then
        vim.api.nvim_echo({
          { "- Trashy utility not installed. Make sure to install it first\n", "ErrorMsg" },
          { "- On Arch Linux, run `cargo install trashy` or find the package from AUR\n", nil },
        }, false, {})
        return
      else
        trash_cmd = "trashy"
      end
    else
      -- macOS fallback to 'trash'
      if vim.fn.executable("trash") == 0 then
        vim.api.nvim_echo({
          { "- Trash utility not installed. Make sure to install it first\n", "ErrorMsg" },
          { "- On macOS, run `brew install trash`\n", nil },
        }, false, {})
        return
      else
        trash_cmd = "trash"
      end
    end

    -- Prompt for confirmation before deleting the file
    vim.ui.input({
      prompt = "Type 'del' to delete the file '" .. current_file .. "': ",
    }, function(input)
      if input == "del" then
        -- Delete the file using the appropriate trash command
        local success, _ = pcall(function()
          vim.fn.system({ trash_cmd, vim.fn.fnameescape(current_file) })
        end)
        if success then
          vim.api.nvim_echo({
            { "File deleted from disk:\n", "Normal" },
            { current_file, "Normal" },
          }, false, {})
          -- Close the buffer after deleting the file
          vim.cmd("bd!")
        else
          vim.api.nvim_echo({
            { "Failed to delete file:\n", "ErrorMsg" },
            { current_file, "ErrorMsg" },
          }, false, {})
        end
      else
        vim.api.nvim_echo({
          { "File deletion canceled.", "Normal" },
        }, false, {})
      end
    end)
  else
    vim.api.nvim_echo({
      { "No file to delete", "WarningMsg" },
    }, false, {})
  end
end

-- FIX: testing.

-- _G.toggle_checkbox_with_date = function()
--   -- Get the current line content
--   local line = vim.api.nvim_get_current_line()

--   -- Patterns to detect checkboxes
--   local checkbox_pattern = "^%s*%- %[(x|o| )%]"

--   -- Check if the line has a checkbox
--   local has_checkbox = string.match(line, checkbox_pattern)

--   if not has_checkbox then
--     -- If no checkbox is found, prepend '- [ ] ' to the line
--     local indent = line:match("^(%s*)") or ""
--     local new_line = indent .. "- [ ] " .. line:sub(#indent + 1)
--     vim.api.nvim_set_current_line(new_line)
--   else
--     -- If a checkbox is present, toggle it using bullets.vim
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(bullets-toggle-checkbox)", true, false, true), "n", true)
--   end
-- end

-- -- Map this function to `g<space>`
-- vim.api.nvim_set_keymap("n", "g<space>", ":lua toggle_checkbox_with_date()<CR>", { noremap = true, silent = true })

-- Map this function to `g<space>`
-- vim.api.nvim_set_keymap('n', 'g<space>', ":lua add_checkbox_with_date()<CR>", { noremap = true, silent = true, buffer = true })

-- FIX: remove this? or let obsidian.nvim still has it?
local obsidian_path = "~/obsidian-syncthing"

-- my current macos has different directory.
if os_name == os_util.OSX then
  obsidian_path = "~/My Drive/obsidian-vault"
end

local my_img_folder = "_resources/"
local notes_subdir = "inbox"
local obsidian_extract_note_desc = printf("Extract Note in ") .. notes_subdir

return {
  -- NOTE: an extention of markdown from lazyvim's
  {
    "richardbizik/nvim-toc",
    event = "VeryLazy",
    config = function()
      require("nvim-toc").setup({})
    end,
  },

  {
    "dkarter/bullets.vim",
    event = "VeryLazy",
    config = function()
      -- You can set any specific bullet.vim settings here
      vim.g.bullets_enabled_file_types = { "markdown", "text" }
      vim.g.bullets_outline_levels = { "num", "abc", "std", "-", "+" } -- Custom bullet levels
      vim.g.bullets_enable_in_empty_buffers = 0 -- default = 1
      vim.g.bullets_set_mappings = 0 -- disable default mappings not working on nvim. need to disable the keymaps manually.
      -- FIX: check linkarzu continue outline vim in youtube

      -- local del = vim.keymap.del
      -- -- delete the default bullet keymaps. doesnt work on nvim. -- TODO: find the fix.
      -- del("n", "<leader>x")
      -- del("i", "<C-T>")
      -- del("i", "<C-D>")

      -- -- FIX: dont use oabsiain custom keymaps that i made? use bullet nvim bullets toggle?
    end,
  },

  -- FIX:  add this https://github.com/hedyhli/outline.nvim

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    event = "VeryLazy",
    -- enabled = false, -- disabled plugin
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "work",
            path = obsidian_path,
          },
        },
        notes_subdir = notes_subdir,
        new_notes_location = "notes_subdir",
        disable_frontmatter = true,
        templates = {
          subdir = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M:%S",
        },

        -- TODO: update this to create work's todo.
        -- create its template using the daily todo in GUI (see Daily notes core plugin's option).
        -- create shell command that when creating new todo works alongside GUI core plugin.
        -- need to refactor the directory structure. currently it is inside nested folder of Office.
        -- change it "work/daily-todo" to host all daily todos. create a shell to mv done todo to "work/done".
        -- create new dir "work/todo" to host all of the todos that will be linked to "work/daily-todo".
        -- create new dir "work/done" to host all of the todos that has been done.
        -- use the current date like "Thu 20 Jun 2024", or change it?
        -- the template is "Office/Stand up/Daily Todo/Daily Todo template". it will use the same template but the file will be moved.
        -- update keybindings for daily notes.
        daily_notes = {
          folder = "work/daily-todo",
          -- Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d",
          -- Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y",
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = nil,
        },

        ui = {
          enable = true, -- set to false to disable all additional syntax features
          update_debounce = 200, -- update delay after a text change (in milliseconds)
          max_file_length = 5000, -- disable UI features for files with more than this many lines
          -- Define how various check-boxes are displayed
          checkboxes = {
            -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["X"] = { char = "", hl_group = "ObsidianDone" },
            ["o"] = { char = "󰱒", hl_group = "ObsidianPartiallyDone" },
            [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
            ["!"] = { char = "", hl_group = "ObsidianImportant" },
            -- Replace the above with this if you don't have a patched font:
            -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
            -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

            -- You can also add more custom ones...
          },
          -- Use bullet marks for non-checkbox lists.
          bullets = { char = "•", hl_group = "ObsidianBullet" },
          external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
          -- Replace the above with this if you don't have a patched font:
          -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
          reference_text = { hl_group = "ObsidianRefText" },
          highlight_text = { hl_group = "ObsidianHighlightText" },
          tags = { hl_group = "ObsidianTag" },
          block_ids = { hl_group = "ObsidianBlockID" },
          hl_groups = {
            -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
            ObsidianTodo = { bold = true, fg = "#f78c6c" },
            ObsidianDone = { bold = true, fg = "#89ddff" },
            ObsidianPartiallyDone = { bold = true, fg = "#f0e4b1" },
            ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
            ObsidianTilde = { bold = true, fg = "#ff5370" },
            ObsidianImportant = { bold = true, fg = "#d73128" },
            ObsidianBullet = { bold = true, fg = "#89ddff" },
            ObsidianRefText = { underline = true, fg = "#c792ea" },
            ObsidianExtLinkIcon = { fg = "#c792ea" },
            ObsidianTag = { italic = true, fg = "#89ddff" },
            ObsidianBlockID = { italic = true, fg = "#89ddff" },
            ObsidianHighlightText = { bg = "#75662e" },
          },
        },

        mappings = {}, -- disable default keybindings.
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },
      })
    end,
    keys = {
      { "<leader>og", "<cmd>ObsidianFollowLink<cr>", desc = printf("Go to Linked File"), mode = "n" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = printf("Open List of Backlinks"), mode = "n" },
      { "<leader>oe", "<cmd>ObsidianExtractNote<cr>", desc = obsidian_extract_note_desc, mode = "v" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = printf("Find Matching Note and Create Link"), mode = "v" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = printf("List Links in Current Note"), mode = "n" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = printf("Search or Create New Note"), mode = "n" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = printf("Open File in GUI"), mode = "n" },
      -- stylua: ignore
      { "<leader>oc", function() return toggle_checkbox_and_date() end, desc = printf "Toggle Checkbox",                     mode = "n" },
      -- stylua: ignore
      { "gt",         function() return toggle_checkbox_and_date() end, desc = printf "Toggle Checkbox",                     mode = "n" },
      -- { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = printf"Obsidian Paste Image", mode = "n" }, -- NOTE: this suck. use the plugin below instead.
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, _)
      autocmd("Filetype", {
        group = markdown_keymaps,
        pattern = { "md", "markdown" }, -- FIX: README.md will have buggy keymaps. find the fix or rename it other than README.md
        callback = function()
          vim.schedule(function()
            local set = vim.keymap.set
            set("n", "<leader>l?", function()
              print("test")
            end, { buffer = true, desc = printf("Other Markdown Keymaps") }) -- FIX: add a print function to print the keymaps
            set("n", "<leader>lc", "<cmd>TOC<cr>", { buffer = true, desc = printf("Generate Table of Contents") })
            set({ "n", "v" }, "gN", "<Plug>(bullets-renumber)", { buffer = true, desc = printf("Renumber Bullets") })
            set("n", "g<space>", "<Plug>(bullets-toggle-checkbox)", { buffer = true, desc = printf("Toggle Checkbox") }) -- cannot do visual mode.
            -- FIX: just create a function that identical to below. but only create checkbox when there is no checkbox.
            set("i", "<cr>", "<Plug>(bullets-newline)", { buffer = true, desc = printf("Bullets Newline in insert mode") })
            set("i", "<c-cr>", "<cr>", { buffer = true, desc = printf("Normal Newline in insert mode") })
            set("n", "o", "<Plug>(bullets-newline)", { buffer = true, desc = printf("Newline in normal mode") })
            set("n", ">>", "<Plug>(bullets-demote)", { buffer = true, desc = printf("Demote Bullet") })
            set("n", "<<", "<Plug>(bullets-promote)", { buffer = true, desc = printf("Promote Bullet") })
            set("v", ">", "<Plug>(bullets-demote)", { buffer = true, desc = printf("Demote Bullet") })
            set("v", "<", "<Plug>(bullets-promote)", { buffer = true, desc = printf("Promote Bullet") })

            -- Keymap to delete the current file
            set("n", "<leader>fD", function()
              delete_current_file()
            end, { desc = printf("Delete current file") })

            -- FIX: check this.
            --                                             *bullets-:SelectCheckboxInside*
            -- :SelectCheckboxInside  Visually selects the contents of a checkbox related to
            --                        the current item the cursor is on (works only in normal
            --                        mode)

            local wk = require("which-key")
            local opts = { prefix = "<leader>", buffer = 0 }
            local mappings = {
              l = {
                name = "+lsp (marksman)",
                b = {
                  name = "+bullet",
                },
              },
            }

            wk.add(mappings, opts)
          end)
        end,
      })
    end,
  },
}

-- TODO: update or fix the function below.
-- generate a function that only handle the symbol and date like below but leave the checkbox to be done by bullets.vim.
-- the logic is like this: (will always call <Plug>(bullets-toggle-checkbox) first)
-- it will remove date if the checkbox is checked / - [X] and makes it unchecked / - [ ]
-- it will add date if the checkbox is unchecked / - [] and makes it checked / - [X]
-- it will add date if the checkbox is partially checked / - [o] and makes it checked / - [X]
-- it will remove date if the checkbox is partially checked / - [o] and makes it unchecked / - [ ]
-- -- Define the custom function to toggle checkbox and manage date and symbol
-- local function toggle_checkbox_and_date()
--   -- Get the current date in the desired format
--   local date = os.date("%Y-%m-%d")

--   -- Define the symbol and date string
--   local symbol_and_date = "✅ " .. date

--   -- Get the current line content
--   local line = vim.api.nvim_get_current_line()

--   -- Check if the line has a checkbox
--   local checkbox_pattern = "^(%s*)%- %[ %]"
--   local checked_pattern = "^(%s*)%- %[x%]"

--   if string.match(line, checkbox_pattern) then
--     -- Replace '- [ ]' with '- [x]' and append the symbol and date
--     local new_line = line:gsub(checkbox_pattern, "%1- [x]") .. " " .. symbol_and_date
--     vim.api.nvim_set_current_line(new_line)
--   elseif string.match(line, checked_pattern) then
--     -- Replace '- [x]' with '- [ ]' and remove the symbol and date
--     local new_line = line:gsub(checked_pattern, "%1- [ ]"):gsub(" ✅ %d%d%d%d%-%d%d%-%d%d$", "")
--     vim.api.nvim_set_current_line(new_line)
--   elseif line:match("^%s*$") then
--     -- If the line is empty or only contains whitespace, add '- [ ] ' and place the cursor at the correct position
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] "
--     vim.api.nvim_set_current_line(new_line)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>A", true, false, true), "n", true)
--   else
--     -- Prepend '- [ ]' to the line if it doesn't have a checkbox
--     local indent = line:match("^(%s*)")
--     local new_line = indent .. "- [ ] " .. line:sub(#indent + 1)
--     vim.api.nvim_set_current_line(new_line)
--   end
-- end

-- _G.toggle_checkbox_with_date = function()
--   -- Get the current line content
--   local line = vim.api.nvim_get_current_line()

--   -- Patterns to detect checkboxes
--   local checkbox_pattern = "^(%s*)%- %[[x ]?%]" -- Matches any checkbox state (- [ ], - [x], - [o])
--   local no_checkbox_pattern = "^%s*$" -- Matches empty or whitespace lines

--   -- If the line does not have any checkbox, add '- [ ]'
--   if not string.match(line, checkbox_pattern) then
--     local indent = line:match("^(%s*)") or ""
--     local new_line = indent .. "- [ ] " .. line:sub(#indent + 1)
--     vim.api.nvim_set_current_line(new_line)
--   end

--   -- Call <Plug>(bullets-toggle-checkbox) to handle checkbox state first
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(bullets-toggle-checkbox)", true, false, true), "n", true)

--   -- Delay to allow bullets.vim to update the checkbox state
--   vim.defer_fn(function()
--     -- Get the current date in the desired format
--     local date = os.date("%Y-%m-%d")

--     -- Define the symbol and date string
--     local symbol_and_date = "✅ " .. date

--     -- Get the updated line content after <Plug>(bullets-toggle-checkbox)
--     line = vim.api.nvim_get_current_line()

--     -- Patterns to detect different checkbox states
--     local checked_pattern = "^(%s*)%- %[x%]" -- Checked
--     local unchecked_pattern = "^(%s*)%- %[ %]" -- Unchecked
--     local partial_pattern = "^(%s*)%- %[o%]" -- Partially checked
--     local custom_pattern = " ✅ %d%d%d%d%-%d%d%-%d%d$" -- Symbol and date pattern

--     -- If the checkbox is checked, add the date if not present
--     if string.match(line, checked_pattern) then
--       -- If no date, add the symbol and date
--       if not string.match(line, custom_pattern) then
--         vim.api.nvim_set_current_line(line .. " " .. symbol_and_date)
--       end

--     -- If the checkbox is unchecked or partially checked, remove the date if present
--     elseif string.match(line, unchecked_pattern) or string.match(line, partial_pattern) then
--       -- If the line has a date, remove it
--       if string.match(line, custom_pattern) then
--         local new_line = line:gsub(custom_pattern, "")
--         vim.api.nvim_set_current_line(new_line)
--       end
--     end
--   end, 50) -- Slight delay to ensure `bullets.vim` processes first
-- end
-- -- Map this function to `g<space>` globally
-- vim.api.nvim_set_keymap("n", "g<space>", ":lua toggle_checkbox_with_date()<CR>", { noremap = true, silent = true })
