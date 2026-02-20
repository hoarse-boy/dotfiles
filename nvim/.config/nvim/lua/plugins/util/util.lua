-- general util functions
local util = {}
util.WEZTERM = "wezterm"
util.KITTY = "kitty"
util.UNKNOWN = "unknown"

-- function util.get_terminal_emulator_by_term()
--   local term_program = vim.fn.getenv("TERM_PROGRAM")
--   local term = vim.fn.getenv("TERM")

--   if term_program == "WezTerm" then
--     return WEZTERM
--   elseif term == "xterm-kitty" then
--     return KITTY
--   else
--     return UNKNOWN
--   end
-- end

-- shared project root cache
util._project_root = util._project_root or nil

local function resolve_project_root()
  if util._project_root then
    return util._project_root
  end

  local cwd = vim.fn.getcwd()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

  if git_root and git_root ~= "" and vim.v.shell_error == 0 then
    util._project_root = git_root
  else
    util._project_root = cwd
  end

  return util._project_root
end

function util.get_terminal()
  if vim.fn.getenv("KITTY_WINDOW_ID") ~= vim.NIL then
    return "kitty"
  elseif vim.fn.getenv("GHOSTTY_WINDOW_ID") ~= vim.NIL then
    return "ghostty"
  elseif vim.fn.getenv("WEZTERM_EXECUTABLE") ~= vim.NIL then
    return "wezterm"
  else
    return vim.fn.getenv("TERM") or "unknown"
  end
end

-- piled up swapfiles overtime will cause nvim / noice to failed to handle the prompt to recover, edit, or delete the swapfile.
-- if that the case, use the function to delete the swapfile folder.
function util.delete_swap_folder()
  -- Path to Neovim's swap folder
  local swap_folder = vim.fn.stdpath("state") .. "/swap/"

  -- Check if the swap folder exists
  if vim.fn.isdirectory(swap_folder) == 1 then
    -- Prompt the user for confirmation
    local answer = vim.fn.input("Are you sure you want to delete the swap folder and its contents? (y/n): ")

    -- Proceed only if the user confirms with 'y'
    if answer == "y" then
      -- Delete the entire swap folder and its contents
      local deleted = vim.fn.delete(swap_folder, "rf") -- "rf" flag removes recursively and forcefully
      if deleted == 0 then
        print("Successfully deleted swap folder and all its contents.")
      else
        print("Failed to delete swap folder.")
      end
    else
      print("Aborted: Swap folder deletion cancelled.")
    end
  else
    print("Swap folder not found.")
  end
end

-- Function to run Prettier on selected text without overwriting on error
-- for now use this command `!prettier --parser json<CR>` as this function is very buggy.
function util.format_json_selection()
  local start_line, _ = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_line, _ = unpack(vim.fn.getpos("'>"), 2, 3)
  local lines = vim.fn.getline(start_line, end_line)

  -- Extract selected text and run Prettier command
  local json_text = table.concat(lines, "\n")
  local cmd = "echo " .. vim.fn.shellescape(json_text) .. " | prettier --parser json"

  -- Run Prettier and capture output
  local result = vim.fn.system(cmd)

  -- Check for errors
  if vim.v.shell_error == 0 then
    -- Replace selection with formatted text on success
    vim.fn.setline(start_line, vim.split(result, "\n"))
  else
    vim.notify("Prettier formatting failed", vim.log.levels.ERROR)
  end
end

-- FIX: still has sonme bugs. when the cursor is in upper lines
-- Function to wrap selection with Markdown code block markers
-- currently use surround nvim custom func. remove this?
function util.wrap_markdown_code_block(filetype)
  -- -- Get the start and end of the visual selection
  -- local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  -- local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  -- print("start row " , start_row , "end row " , end_row) -- FIX:

  -- -- Construct the code block markers with the filetype
  -- local start_marker = string.format("```%s", filetype)
  -- local end_marker = "```"

  -- -- Insert the start and end code block markers
  -- vim.api.nvim_buf_set_lines(0, start_row - 1, start_row - 1, false, { start_marker }) -- Insert before the first selected line
  -- vim.api.nvim_buf_set_lines(0, end_row + 1, end_row + 1, false, { end_marker }) -- Insert after the last selected line
  -- end
  -- Get the start and end of the visual selection using vim.fn
  -- Get the start and end of the visual selection using vim.fn
  -- Get the start and end of the visual selection using vim.fn
  local start_row = vim.fn.line("v") -- Line number of the start of the visual selection
  local end_row = vim.fn.line(".") -- Line number of the end of the visual selection

  -- Construct the code block markers with the filetype
  local start_marker = string.format("```%s", filetype) -- Start marker with filetype
  local end_marker = "```" -- End marker

  -- Insert the start marker before the first selected line only if it's not already there
  if vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1] ~= start_marker then
    vim.api.nvim_buf_set_lines(0, start_row - 1, start_row - 1, false, { start_marker })
  end

  -- Insert the end marker after the last selected line only if it's not already there
  if vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1] ~= end_marker then
    -- Change this to end_row instead of end_row + 1 to avoid deleting the line
    vim.api.nvim_buf_set_lines(0, end_row + 1, end_row + 1, false, { end_marker })
  end
end -- FIX: remove?

-- modify existing dashboard shortcut in config.center. the one showing when launching nvim.
--- @param dashboard_keys_table table: The dashboard keys table.
--- @param current_keymap string: The current keymap.
--- @param new_action string | function: The new action.
--- @param new_desc string: The new description.
function util.update_dashboard_shortcut(dashboard_keys_table, current_keymap, new_action, new_desc)
  -- for _, item in ipairs(opts.config.center) do -- this is used if the dashboard plugin is dashboard.nvim
  for _, item in ipairs(dashboard_keys_table) do
    if item.key == current_keymap then
      item.action = new_action
      item.desc = new_desc
    end
  end
end

--- Removes an item from the dashboard keys table.
--- the value of `dashboard_keys_table` is dynamic according to the dashboard plugin used.
--- example for snacks's dashboard the keys table is `opts.dashboard.preset.keys`.
--- @param dashboard_keys_table table: The dashboard keys table.
--- @param key_to_remove string: The key to remove from the dashboard keys table.
function util.remove_dashboard_item(dashboard_keys_table, key_to_remove)
  for index, item in ipairs(dashboard_keys_table) do
    if item.key == key_to_remove then
      table.remove(dashboard_keys_table, index)
      break
    end
  end
end

-- function util.check_or_create_launch_json()
--   -- Get the current working directory
--   local cwd = vim.fn.getcwd()
--   local launch_path = cwd .. "/.vscode/launch.json"

--   -- Check if .vscode/launch.json exists
--   if vim.fn.filereadable(launch_path) == 1 then
--     -- File exists, open it
--     vim.cmd("edit " .. launch_path)
--     return
--   end

--   -- Ask user if they want to create the file
--   local confirm = vim.fn.input(string.format("Create launch.json in %s? (y/n): ", cwd))

--   if confirm:lower() ~= "y" then
--     print("\nOperation cancelled")
--     return
--   end

--   -- Create .vscode directory if it doesn't exist
--   local vscode_dir = cwd .. "/.vscode"
--   if vim.fn.isdirectory(vscode_dir) == 0 then
--     vim.fn.mkdir(vscode_dir, "p")
--   end

--   -- Create empty file and open it
--   local file = io.open(launch_path, "w")
--   if file then
--     file:close()
--     vim.cmd("edit " .. launch_path)
--     print("\nCreated launch.json")
--   else
--     print("\nError: Could not create launch.json")
--   end
-- end -- DEL: . DELETE LINES LATER

-- cache resolved base dir per session
util._launch_base_dir = util._launch_base_dir or nil

-- function util.check_or_create_launch_json()
--   -- Get the current working directory
--   local cwd = vim.fn.getcwd()

--   -- Resolve git root once per session, fallback to cwd
--   if not util._launch_base_dir then
--     local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

--     if git_root and git_root ~= "" and vim.v.shell_error == 0 then
--       util._launch_base_dir = git_root
--     else
--       util._launch_base_dir = cwd
--     end
--   end

--   local base_dir = util._launch_base_dir
--   local launch_path = base_dir .. "/.vscode/launch.json"

--   -- Check if .vscode/launch.json exists
--   if vim.fn.filereadable(launch_path) == 1 then
--     -- File exists, open it
--     vim.cmd("edit " .. launch_path)
--     return
--   end

--   -- Ask user if they want to create the file
--   local confirm = vim.fn.input(string.format("Create launch.json in %s? (y/n): ", base_dir))

--   if confirm:lower() ~= "y" then
--     print("\nOperation cancelled")
--     return
--   end

--   -- Create .vscode directory if it doesn't exist
--   local vscode_dir = base_dir .. "/.vscode"
--   if vim.fn.isdirectory(vscode_dir) == 0 then
--     vim.fn.mkdir(vscode_dir, "p")
--   end

--   -- Create empty file and open it
--   local file = io.open(launch_path, "w")
--   if file then
--     file:close()
--     vim.cmd("edit " .. launch_path)
--     print("\nCreated launch.json")
--   else
--     print("\nError: Could not create launch.json")
--   end
-- end -- DEL: . DELETE LINES LATER

function util.check_or_create_envrc()
  -- Find project root by looking for .git or .envrc in parent directories
  local current_file = vim.fn.expand("%:p")
  local current_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()
  local root_dir = nil
  local found_git = false

  -- Search upwards for .git or .envrc
  local dir = current_dir
  while true do
    -- Check for .git directory (preferred)
    local git_path = vim.fn.glob(dir .. "/.git")
    if git_path ~= "" and not found_git then
      root_dir = dir
      found_git = true
      -- Don't break yet - there might be an .envrc higher up
    end

    -- Check for .envrc file
    local envrc_path = vim.fn.glob(dir .. "/.envrc")
    if envrc_path ~= "" then
      root_dir = dir
      break -- .envrc found, use this as root
    end

    -- Move to parent directory
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then -- Reached filesystem root
      break
    end
    dir = parent
  end

  if root_dir and vim.fn.glob(root_dir .. "/.envrc") ~= "" then
    -- .envrc exists, open it
    local envrc_path = root_dir .. "/.envrc"
    vim.cmd("edit " .. envrc_path)
    return
  end

  -- Determine where to create .envrc
  local create_dir = root_dir or current_dir
  local prompt_msg = string.format("No .envrc found. Create one in %s? (Enter=Yes, n=No)", create_dir)

  local response = vim.fn.input(prompt_msg)
  if response == "" then
    -- User pressed Enter - create the file
    local envrc_path = create_dir .. "/.envrc"
    vim.fn.writefile({}, envrc_path)
    vim.cmd("edit " .. envrc_path)
    vim.notify(string.format("Created .envrc in %s", create_dir), vim.log.levels.INFO)
  elseif response:lower() == "n" then
    -- User cancelled
    vim.notify("Creation of .envrc cancelled", vim.log.levels.INFO)
  end
end

-- still cannot command to type 'gr' etc to simulate go to reference without manual typing.
function util.GotoEnclosingSymbolName()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result)
    if err or not result then
      return
    end

    local row = params.position.line
    local col = params.position.character

    local function in_range(r)
      if row < r.start.line or row > r["end"].line then
        return false
      end
      if row == r.start.line and col < r.start.character then
        return false
      end
      if row == r["end"].line and col > r["end"].character then
        return false
      end
      return true
    end

    local function walk(symbols)
      for _, sym in ipairs(symbols) do
        if sym.range and in_range(sym.range) then
          if sym.selectionRange then
            local r = sym.selectionRange.start
            vim.api.nvim_win_set_cursor(0, { r.line + 1, r.character })
            return true
          end
        end
        if sym.children and walk(sym.children) then
          return true
        end
      end
    end

    walk(result)
  end)
end

-- cache resolved base dir per session
util._env_base_dir = util._env_base_dir or nil

-- function util.check_or_create_env()
--   -- resolve base dir only once
--   if not util._env_base_dir then
--     local cwd = vim.fn.getcwd()
--     local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

--     if git_root and git_root ~= "" and vim.v.shell_error == 0 then
--       util._env_base_dir = git_root
--     else
--       util._env_base_dir = cwd
--     end
--   end

--   local base_dir = util._env_base_dir
--   local env_path = base_dir .. "/.env"

--   -- check if .env exists
--   if vim.fn.filereadable(env_path) == 1 then
--     -- file exists, open it
--     vim.cmd("edit " .. env_path)
--     return
--   end

--   -- ask user if they want to create the file
--   local confirm = vim.fn.input(string.format("create .env in %s? (y/n): ", base_dir))

--   if confirm:lower() ~= "y" then
--     print("\noperation cancelled")
--     return
--   end

--   -- create empty file and open it
--   local file = io.open(env_path, "w")
--   if file then
--     file:close()
--     vim.cmd("edit " .. env_path)
--     print("\ncreated .env")
--   else
--     print("\nerror: could not create .env")
--   end
-- end -- DEL: . DELETE LINES LATER

function util.check_or_create_launch_json()
  local base_dir = resolve_project_root()
  local launch_path = base_dir .. "/.vscode/launch.json"

  if vim.fn.filereadable(launch_path) == 1 then
    vim.cmd("edit " .. launch_path)
    return
  end

  local confirm = vim.fn.input(string.format("Create launch.json in %s? (y/n): ", base_dir))
  if confirm:lower() ~= "y" then
    print("\nOperation cancelled")
    return
  end

  local vscode_dir = base_dir .. "/.vscode"
  if vim.fn.isdirectory(vscode_dir) == 0 then
    vim.fn.mkdir(vscode_dir, "p")
  end

  local file = io.open(launch_path, "w")
  if file then
    file:close()
    vim.cmd("edit " .. launch_path)
    print("\nCreated launch.json")
  else
    print("\nError: Could not create launch.json")
  end
end

function util.check_or_create_env()
  local base_dir = resolve_project_root()
  local env_path = base_dir .. "/.env"

  if vim.fn.filereadable(env_path) == 1 then
    vim.cmd("edit " .. env_path)
    return
  end

  local confirm = vim.fn.input(string.format("create .env in %s? (y/n): ", base_dir))
  if confirm:lower() ~= "y" then
    print("\noperation cancelled")
    return
  end

  local file = io.open(env_path, "w")
  if file then
    file:close()
    vim.cmd("edit " .. env_path)
    print("\ncreated .env")
  else
    print("\nerror: could not create .env")
  end
end

return util
