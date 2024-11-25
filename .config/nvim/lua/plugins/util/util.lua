local util = {}
util.WEZTERM = "wezterm"
util.KITTY = "kitty"
util.UNKNOWN = "unknown"

function util.get_terminal_emulator_by_term()
  local term_program = vim.fn.getenv("TERM_PROGRAM")
  local term = vim.fn.getenv("TERM")

  if term_program == "WezTerm" then
    return WEZTERM
  elseif term == "xterm-kitty" then
    return KITTY
  else
    return UNKNOWN
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

return util