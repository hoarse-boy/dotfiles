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
    vim.api.nvim_buf_set_lines(0, row, row, false, { "", "- [ ]  ", "", "---" }) -- insert formatted lines
    vim.api.nvim_win_set_cursor(0, { row + 2, 6 }) -- move cursor inside the checklist

    -- vim.api.nvim_buf_set_lines(0, row, row, false, { "", "---", "", "- [ ]  " }) -- insert formatted lines
    -- vim.api.nvim_win_set_cursor(0, { row + 4, 6 }) -- move cursor inside the checklist

    vim.cmd("startinsert") -- enter insert mode
  else
    vim.api.nvim_buf_set_lines(0, row, row, false, { "", "---", "" }) -- insert '---' and an empty line
    vim.api.nvim_win_set_cursor(0, { row + 3, 0 }) -- move cursor 3 lines down
  end
end

function M.insert_latest_screenshot()
  -- Get paths
  local screenshot_dir = os.getenv("HOME") .. "/Pictures/Screenshots"
  local assets_dir = vim.fn.expand("~/jho-notes/assets")

  -- Find latest AVIF screenshot
  local handle = io.popen(string.format('ls -t "%s"/*.avif 2>/dev/null | head -n 1', screenshot_dir))
  local latest_avif = handle:read("*a"):gsub("\n", "")
  handle:close()

  if latest_avif == "" then
    vim.notify("No AVIF screenshots found in " .. screenshot_dir, vim.log.levels.WARN)
    return
  end

  -- Prompt for image name
  vim.ui.input({
    prompt = "Image name (leave empty for 'image'): ",
    default = "",
  }, function(input)
    if not input then
      return
    end -- User cancelled

    local base_name = input:gsub("%s+", "-"):gsub("[^%w%-]", ""):lower()
    if base_name == "" then
      base_name = "image"
    end

    -- Generate filename with timestamp
    local timestamp = os.date("%Y-%m-%d-%H-%M-%S")
    local new_filename = base_name .. "-" .. timestamp .. ".avif"
    local dest_path = assets_dir .. "/" .. new_filename

    -- Copy file
    os.execute(string.format('cp "%s" "%s"', latest_avif, dest_path))

    -- Insert markdown link
    local markdown_link = string.format("![%s](./assets/%s)", base_name, new_filename)
    vim.api.nvim_put({ markdown_link }, "", false, true)

    vim.notify("Inserted: " .. markdown_link)
  end)
end

function M.screenshot_picker()
  -- Configurable paths
  local assets_dir = vim.fn.expand("~/jho-notes/assets")

  -- Scan directories for AVIF files
  local scan = require("plenary.scandir")
  local images = {}

  local function safe_scan(dir)
    if vim.fn.isdirectory(dir) == 1 then
      return scan.scan_dir(dir, {
        hidden = false,
        only_files = true,
        search_pattern = "%.avif$",
      }) or {}
    end
    return {}
  end

  vim.list_extend(images, safe_scan(assets_dir))

  if #images == 0 then
    vim.notify("No AVIF images found in:\n" .. assets_dir, vim.log.levels.WARN)
    return
  end

  -- Prepare items for picker
  local items = {}
  for _, img_path in ipairs(images) do
    local img_name = vim.fn.fnamemodify(img_path, ":t")
    local clean_name = img_name:gsub("%.avif$", ""):gsub("%d%d%d%d%-%d%d%-%d%d%-%d%d%-%d%d%-%d%d", ""):gsub("^%-+", ""):gsub("%-+$", ""):gsub("%-+", " "):gsub("^%s*(.-)%s*$", "%1")

    if clean_name == "" then
      clean_name = "screenshot"
    end

    table.insert(items, {
      display = img_name,
      value = {
        path = img_path,
        rel_path = "./" .. vim.fn.fnamemodify(img_path, ":~:."),
        clean_name = clean_name,
      },
    })
  end

  -- TODO: make it to show image preview like snacks.files
  -- Show picker
  require("snacks.picker").select(items, {
    prompt = "Select Image:",
    format_item = function(item)
      return "🖼️ " .. item.display
    end,
    previewer = function(item)
      return {
        type = "text",
        lines = {
          "File: " .. item.display,
          "Path: " .. item.value.path,
          "Alt Text: " .. item.value.clean_name,
          "",
          "Press Enter to insert Markdown link",
        },
      }
    end,
  }, function(choice)
    if choice then
      local markdown_link = string.format("![%s](%s)", choice.value.clean_name, choice.value.rel_path)
      vim.api.nvim_put({ markdown_link }, "", false, true)
    end
  end)
end

-- TODO: make the othe rfunc above to use this config M.notes_dir etc.
-- Config
M.notes_dir = vim.fn.expand("~/jho-notes")
M.assets_dir = M.notes_dir .. "/assets"

local function get_current_datetime_suffix()
  return os.date("%Y-%m-%d-%H-%M-%S")
end

local function get_image_path_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based index
  -- Match markdown image pattern ![alt](path)
  local pattern = "!%[.-%]%((.-)%)"

  local start_pos = 1
  while true do
    local img_start, img_end, path = string.find(line, pattern, start_pos)
    if not img_start then
      return nil
    end

    if col >= img_start and col <= img_end then
      -- Normalize path (handle ./assets/... paths)
      if path:match("^%.%/assets/") then
        path = path:gsub("^%.%/", "")
      end
      return path, img_start, img_end
    end
    start_pos = img_end + 1
  end
end

local function confirm_action(prompt, callback)
  vim.ui.select({ "Yes", "No" }, { prompt = prompt }, function(choice)
    if choice == "Yes" then
      callback()
    else
      print("Action cancelled")
    end
  end)
end

local function find_all_markdown_files()
  local cmd = string.format('find "%s" -type f -name "*.md"', M.notes_dir)
  local handle = io.popen(cmd)
  if not handle then
    return {}
  end

  local files = {}
  for file in handle:lines() do
    table.insert(files, file)
  end
  handle:close()

  return files
end

function M.rename_image_under_cursor()
  local path = get_image_path_under_cursor()
  if not path then
    print("No image found under cursor")
    return
  end

  vim.ui.input({
    prompt = "Rename image to: ",
    default = vim.fn.fnamemodify(path, ":t:r"),
  }, function(input)
    if not input or input == "" then
      return
    end

    local full_old_path = M.notes_dir .. "/" .. path
    local ext = vim.fn.fnamemodify(path, ":e")
    if ext ~= "" then
      ext = "." .. ext
    end

    -- Clean up the new name (replace spaces with dashes)
    local new_name = input:gsub("%s+", "-")

    -- Add datetime suffix
    local datetime = get_current_datetime_suffix()
    local final_name = new_name .. "-" .. datetime
    local full_new_path = string.format("%s/%s/%s%s", M.notes_dir, vim.fn.fnamemodify(path, ":h"), final_name, ext)
    local new_path = vim.fn.fnamemodify(full_new_path, ":.")

    -- Rename the file
    os.rename(full_old_path, full_new_path)

    -- Update references
    local updated_files = 0
    local updated_refs = 0
    local files = find_all_markdown_files()

    for _, file in ipairs(files) do
      local content = table.concat(vim.fn.readfile(file), "\n")
      local new_content, count = content:gsub(vim.pesc(path), new_path)

      if count > 0 then
        updated_files = updated_files + 1
        updated_refs = updated_refs + count
        vim.fn.writefile(vim.split(new_content, "\n"), file)

        if vim.fn.expand("%:p") == file then
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(new_content, "\n"))
          end)
        end
      end
    end

    -- Force reload current buffer. to avoid buggy nvim prompt to reload the buffer.
    vim.schedule(function()
      vim.cmd("edit!")
    end)

    vim.print(string.format('Renamed "%s" to "%s"\nUpdated %d references across %d files', path, new_path, updated_refs, updated_files))
  end)
end

function M.delete_image_under_cursor()
  local path, start_pos, end_pos = get_image_path_under_cursor()
  if not path then
    print("No image found under cursor")
    return
  end

  -- First count references in all files
  local affected_files = 0
  local total_refs = 0
  local files = find_all_markdown_files()

  for _, file in ipairs(files) do
    local content = table.concat(vim.fn.readfile(file), "\n")
    local _, count = content:gsub(vim.pesc(path), "")
    if count > 0 then
      affected_files = affected_files + 1
      total_refs = total_refs + count
    end
  end

  -- Show confirmation with reference count
  confirm_action(string.format("Delete image? This will remove %d references across %d files", total_refs, affected_files), function()
    -- Delete from all files
    for _, file in ipairs(files) do
      local content = table.concat(vim.fn.readfile(file), "\n")
      local new_content = content:gsub(vim.pesc(path), "")
      if new_content ~= content then
        vim.fn.writefile(vim.split(new_content, "\n"), file)
      end
    end

    -- Delete the file itself
    local full_path = M.notes_dir .. "/" .. path
    local use_trash = vim.fn.executable("trash-put") == 1 or vim.fn.executable("trash") == 1
    local cmd = use_trash and "trash-put" or "rm"
    if use_trash and vim.fn.executable("trash-put") ~= 1 then
      cmd = "trash" -- fallback to 'trash' if 'trash-put' not available
    end

    os.execute(string.format('%s "%s"', cmd, full_path))

    -- Remove from current buffer immediately
    if start_pos and end_pos then
      local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
      vim.api.nvim_buf_set_text(0, line_num, start_pos - 1, line_num, end_pos, { "" })
    end

    -- Force reload current buffer. to avoid buggy nvim prompt to reload the buffer.
    vim.schedule(function()
      vim.cmd("edit!")
    end)

    vim.print(string.format('Deleted "%s"\nRemoved %d references across %d files', path, total_refs, affected_files))
  end)
end

-- TODO: file preview still not working. need to fix it.
function M.show_image_references()
  local path = get_image_path_under_cursor()
  if not path then
    vim.notify("No image found under cursor", vim.log.levels.WARN)
    return
  end

  -- prepare two escaped patterns: one with "./" and one without
  local pat1 = vim.pesc(path)
  local rel = "./" .. vim.fn.fnamemodify(path, ":.")
  local pat2 = vim.pesc(rel)

  -- Gather references
  local references = {}
  for _, file in ipairs(find_all_markdown_files()) do
    local lines = vim.fn.readfile(file)
    for lnum, line in ipairs(lines) do
      if line:find(pat1) or line:find(pat2) then
        table.insert(references, {
          filename = file,
          lnum = lnum,
          text = line:gsub("^%s+", ""):sub(1, 60) .. (line:len() > 60 and "…" or ""),
        })
      end
    end
  end

  if vim.tbl_isempty(references) then
    vim.notify(("No references found for %q"):format(path), vim.log.levels.INFO)
    return
  end

  -- Build picker items
  local items = vim.tbl_map(function(ref)
    return {
      value = ref,
      display = vim.fn.fnamemodify(ref.filename, ":~:."),
    }
  end, references)

  -- Launch Snacks picker with built-in file preview
  require("snacks.picker").select(items, {
    prompt = "References:",
    preview = "file", -- built-in file previewer
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd("edit " .. choice.value.filename)
    vim.api.nvim_win_set_cursor(0, { choice.value.lnum, 0 })
  end)
end

-- Create commands
vim.api.nvim_create_user_command("DeleteImage", M.delete_image_under_cursor, {})
vim.api.nvim_create_user_command("RenameImage", M.rename_image_under_cursor, {})
vim.api.nvim_create_user_command("ImageReferences", M.show_image_references, {})

return M
