-- all of my custom markdown function goes here.
local M = {}

-- local builtin = require("telescope.builtin")  -- NOTE: dont require like this. it causes the plugin to be called at the start and removing any lazy loading.

local os_util = require("plugins.util.check-os")
local os_name = os_util.get_os_name()

-- Example usage:
-- search_front_matter(nil, "false", "dir")  -- search for all with #work_task and is_done: false
-- search_front_matter('#work_task', nil, "dir")  -- search for just the tag
-- search_front_matter(nil, "true", "dir")   -- search for all with #work_task and is_done: true
--- @param query string | nil The tag pattern to search (default: #work_task)
--- @param is_done_status string | nil The is_done status to search for ("true" or "false")
--- @param dir string The directory to search in
function M.search_front_matter(query, is_done_status, dir) -- FIX: finding false and true are not working
  -- Define the search patterns based on the user input
  local search_pattern = query and query or "#work_task"
  local is_done_pattern = is_done_status and "is_done: " .. is_done_status or ""

  -- Telescope live_grep arguments
  local search_cmd = { "rg", "--no-heading", "--with-filename", "--line-number", "--column" }

  -- Add the pattern for the tag
  if search_pattern ~= "" then
    table.insert(search_cmd, search_pattern)
  end

  -- Add the pattern for the `is_done` status if provided
  if is_done_pattern ~= "" then
    table.insert(search_cmd, "-g")
    table.insert(search_cmd, "*.md")
    table.insert(search_cmd, is_done_pattern)
  end

  --   -- Change the directory where we are searching -- FIX:
  --   teles_find.ChangeDir(dir)

  -- Execute Telescope with the constructed search command
  require("telescope.builtin").live_grep({
    prompt_title = "Search Front Matter",
    search_dirs = { dir }, -- Adjust to your actual directory
    vimgrep_arguments = search_cmd,
  })
end

-- function M.search_front_matter(query, is_done_status, dir) -- FIX: not working
--   -- Define the search patterns based on the user input
--   local search_pattern = query and query or "#work_task"
--   local is_done_pattern = is_done_status and "is_done: " .. is_done_status or ""

--   -- Telescope live_grep arguments (start building the `rg` command)
--   local search_cmd = { "rg", "--no-heading", "--with-filename", "--line-number", "--column" }

--   -- Add the pattern for the tag
--   if search_pattern ~= "" then
--     table.insert(search_cmd, search_pattern)
--   end

--   -- Add the pattern for the `is_done` status if provided
--   if is_done_pattern ~= "" then
--     -- Append both search patterns with an AND condition (i.e., both must be found in the file)
--     table.insert(search_cmd, "--and")
--     table.insert(search_cmd, "--regexp")
--     table.insert(search_cmd, is_done_pattern)
--   end

--   -- Filter by markdown files only
--   table.insert(search_cmd, "-g")
--   table.insert(search_cmd, "*.md")

--   -- Change the directory where we are searching
--   teles_find.ChangeDir(dir)

--   -- Execute Telescope with the constructed search command
--   require("telescope.builtin").live_grep({
--     prompt_title = "Search Front Matter",
--     search_dirs = { dir }, -- Search only in the specified directory
--     vimgrep_arguments = search_cmd, -- Pass our custom `rg` search command
--   })
-- end

function M.delete_current_file()
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

function M.check_or_add_checkbox(enter_insert_mode)
  -- Get the current mode to detect if it's visual or normal
  local mode = vim.api.nvim_get_mode().mode

  -- Function to process a single line (used for both normal and visual modes)
  local function process_line(line)
    local checkbox_pattern = "^(%s*)%- %[ %] "
    local symbol_pattern = "^(%s*)%- %[.-%]"

    if string.match(line, checkbox_pattern) then
      print("Checkbox available")
      return line
    elseif string.match(line, symbol_pattern) then
      print("Symbol present, skipping modification")
      return line
    else
      local indent = line:match("^(%s*)")
      return indent .. "- [ ] " .. line:sub(#indent + 1)
    end
  end

  -- Handle visual mode: process multiple lines
  if mode == "v" or mode == "V" then
    -- Get the selected range in visual mode
    local start_row, start_col = vim.fn.line("v"), vim.fn.col("v")
    local end_row, end_col = vim.fn.line("."), vim.fn.col(".")

    -- Ensure the range is correct regardless of the direction of selection
    if start_row > end_row or (start_row == end_row and start_col > end_col) then
      start_row, end_row = end_row, start_row
    end

    -- Iterate through each line in the selected range
    for row = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
      local new_line = process_line(line)
      vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
    end
  else
    -- Normal mode: process only the current line
    local line = vim.api.nvim_get_current_line()
    local new_line = process_line(line)
    vim.api.nvim_set_current_line(new_line)

    -- Enter insert mode if requested
    if enter_insert_mode then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>A", true, false, true), "n", true)
    end
  end
end

function M.remove_checkbox()
  -- Get the current mode to detect if it's visual or normal
  local mode = vim.api.nvim_get_mode().mode

  -- Function to process a single line (used for both normal and visual modes)
  local function process_line(line)
    local checkbox_pattern = "^(%s*)%- %[.-%] "
    if string.match(line, checkbox_pattern) then
      -- Remove the checkbox and keep the rest of the line
      return line:gsub(checkbox_pattern, "%1")
    end
    return line -- Return the line unchanged if no checkbox is found
  end

  -- Handle visual mode: process multiple lines
  if mode == "v" or mode == "V" then
    -- Get the selected range in visual mode
    local start_row, start_col = vim.fn.line("v"), vim.fn.col("v")
    local end_row, end_col = vim.fn.line("."), vim.fn.col(".")

    -- Ensure the range is correct regardless of the direction of selection
    if start_row > end_row or (start_row == end_row and start_col > end_col) then
      start_row, end_row = end_row, start_row
    end

    -- Iterate through each line in the selected range
    for row = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
      local new_line = process_line(line)
      vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
    end
  else
    -- Normal mode: process only the current line
    local line = vim.api.nvim_get_current_line()
    local new_line = process_line(line)
    vim.api.nvim_set_current_line(new_line)
  end
end

function M.toggle_is_done_in_buffer()
  local target_tag = "#work_task"

  -- Get the lines of the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Initialize variables to track states
  local in_front_matter = false
  local tag_found = false
  local is_done_index = nil

  -- Loop through lines to find the front matter and `#work_task` tag
  for i, line in ipairs(lines) do
    -- Start and end of front matter
    if line:match("^%-%-%-$") then
      in_front_matter = not in_front_matter
    end

    -- Check for the specific tag while in front matter
    if in_front_matter and line:match(target_tag) then
      tag_found = true
    end

    -- Check if 'is_done:' is present and toggle it
    if in_front_matter and line:match("^is_done:") then
      is_done_index = i
      local current_status = line:match("is_done:%s*(%a+)")
      local new_status = (current_status == "false") and "true" or "false"
      lines[i] = "is_done: " .. new_status
    end
  end

  -- If the tag was found and is_done exists, update the buffer
  if tag_found and is_done_index then
    -- Set the modified lines back to the buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    print("Toggled is_done value!")
  else
    print(string.format("Tag '%s' or 'is_done' not found in front matter.", target_tag))
  end
end

function M.delete_image_file()
  local function get_image_path()
    local line = vim.api.nvim_get_current_line()
    local image_pattern = "%[.-%]%((.-)%)"
    local _, _, image_path = string.find(line, image_pattern)
    return image_path
  end

  local image_path = get_image_path()
  if image_path then
    if string.sub(image_path, 1, 4) == "http" then
      vim.api.nvim_echo({
        { "URL image cannot be deleted from disk.", "WarningMsg" },
      }, false, {})
    else
      local current_file_path = vim.fn.expand("%:p:h")
      local absolute_image_path = current_file_path .. "/" .. image_path

      local delete_cmd = ""

      if os_name == "macos" then
        delete_cmd = "/opt/homebrew/bin/trash"
      elseif os_name == "arch" then
        delete_cmd = "trashy"
      end

      -- Check if the command is executable
      if delete_cmd == "" or vim.fn.executable(delete_cmd) == 0 then
        vim.api.nvim_echo({
          { "- Trash utility not installed. Please install it first.\n", "ErrorMsg" },
          { "- On macOS: `brew install trash`\n", nil },
          { "- On Arch Linux: `sudo pacman -S trashy`\n", nil },
        }, false, {})
        return
      end

      -- Prompt for confirmation before deleting the image
      vim.ui.select({ "yes", "no" }, { prompt = "Delete image file? " }, function(choice)
        if choice == "yes" then
          local success, _ = pcall(function()
            vim.fn.system({ delete_cmd, vim.fn.fnameescape(absolute_image_path) })
          end)
          if success then
            vim.api.nvim_echo({
              { "Image file deleted from disk:\n", "Normal" },
              { absolute_image_path, "Normal" },
            }, false, {})
            require("image").clear()
            vim.cmd("edit!")
            vim.cmd("normal! dd")
          else
            vim.api.nvim_echo({
              { "Failed to delete image file:\n", "ErrorMsg" },
              { absolute_image_path, "ErrorMsg" },
            }, false, {})
          end
        else
          vim.api.nvim_echo({
            { "Image deletion canceled.", "Normal" },
          }, false, {})
        end
      end)
    end
  else
    vim.api.nvim_echo({
      { "No image found under the cursor", "WarningMsg" },
    }, false, {})
  end
end

-- example that go to normal mode inside telescope
-- function M.search_moc_files()
--   builtin.find_files({
--     prompt_title = "Search MOC Files",
--     find_command = { "rg", "--files", "--glob", "*moc*" },
--     attach_mappings = function(_, map)
--       map("i", "<esc>", actions.close) -- Close on escape in insert mode
--       return true
--     end,
--   })
-- end

-- function M.search_undone_markdown()
--   -- Pre-filter files containing `is_done: false` in the front matter
--   local handle = io.popen("rg --glob '*.md' --multiline --multiline-dotall -l 'is_done: false[\\s\\S]*---'")
--   local files = {}
--   for file in handle:lines() do
--     table.insert(files, file)
--   end
--   handle:close()

--   -- Pass the filtered files to Telescope
--   require("telescope.builtin").live_grep({
--     prompt_title = "Search Undone Markdown Files",
--     default_text = "", -- Empty default text for user input
--     search_dirs = files, -- Limit search to the pre-filtered files
--   })
-- end

-- search certain pattern in markdown files and shows the filtered files in fzf-lua or telescope.
function M.search_markdown(pattern, prompt)
  -- Determine the ripgrep command based on the pattern
  local rg_command
  if pattern == "is_done: false" then
    rg_command = "rg --glob '*.md' --multiline --multiline-dotall -l 'is_done: false[\\s\\S]*---'"
  else
    rg_command = string.format("rg --glob '*.md' -l '%s'", pattern)
  end

  -- Pre-filter files using rg
  local handle = io.popen(rg_command)
  local files = {}
  for file in handle:lines() do
    table.insert(files, file)
  end
  handle:close()

  -- If no files were found, notify and exit -- FIX:
  if #files == 0 then
    vim.notify("No matching markdown files found", vim.log.levels.WARN)
    return
  end

  -- Check if fzf-lua is available
  local has_fzflua, fzflua = pcall(require, "fzf-lua")
  if has_fzflua then
    prompt = string.format("%s> ", prompt or "Search Markdown Files")

    fzflua.fzf_exec(files, {
      prompt = prompt or "Search Markdown Files> ",
      previewer = "builtin",
      actions = {
        ["default"] = function(selected)
          if selected and #selected > 0 then
            vim.cmd("edit " .. vim.fn.fnameescape(selected[1]))
          end
        end,
      },
      fzf_opts = {
        ["--preview"] = "bat --style=full --color=always {} 2>/dev/null || cat {}",
      },
    })
  else
    -- Fallback to Telescope
    require("telescope.builtin").find_files({
      prompt_title = prompt or "Search Markdown Files",
      default_text = "",
      find_command = { "echo", table.concat(files, "\n") },
    })
  end
end

function M.insert_separator(with_todo)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0)) -- get current cursor position

  if with_todo then
    vim.api.nvim_buf_set_lines(0, row, row, false, { "", "---", "", "- [ ]  " }) -- insert formatted lines
    vim.api.nvim_win_set_cursor(0, { row + 4, 6 }) -- move cursor inside the checklist
    vim.cmd("startinsert") -- enter insert mode
  else
    vim.api.nvim_buf_set_lines(0, row, row, false, { "", "---", "" }) -- insert '---' and an empty line
    vim.api.nvim_win_set_cursor(0, { row + 3, 0 }) -- move cursor 3 lines down
  end
end

return M
