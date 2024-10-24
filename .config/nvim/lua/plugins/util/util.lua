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

return util
