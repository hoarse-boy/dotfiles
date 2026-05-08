-- all related util function to find files
local M = {}

-- Change global directory and launch corresponding picker.
-- call other func without chdir to avoid changing global dir causing harpoon and todo-comments to not work.
-- such func is Snacks.dashboard.pick('files').
-- or Snacks.picker.files({ cwd = directory })
---@param directory string The directory to search in
function M.change_dir_and_find_files(directory)
  vim.fn.chdir(directory) -- this is needed to globally change the dir

  if vim.g.lazyvim_picker == "snacks" then
    Snacks.picker.files()
  else
    local ok, fzflua = pcall(require, "fzf-lua")
    if ok then
      fzflua.files({ cwd = directory })
    else
      require("telescope.builtin").find_files({ cwd = directory })
    end
  end
end

--- Change directory and search for files using ripgrep
---@param directory string The directory to search in
function M.change_dir_and_live_grep(directory)
  vim.fn.chdir(directory) -- Change the global working directory

  if vim.g.lazyvim_picker == "snacks" then
    require("snacks.picker").grep() -- snacks grep does not have cwd option.
  else
    local ok, fzflua = pcall(require, "fzf-lua")
    if ok then
      fzflua.live_grep({ cwd = directory })
    else
      require("telescope.builtin").live_grep({ cwd = directory })
    end
  end
end

--- Open a specific file in Neovim
---@param file_name string The file to open
---@param dir string The directory containing the file
function M.open_a_file(file_name, dir)
  -- Ensure correct path formatting
  local file_path = vim.fn.expand(dir .. "/" .. file_name)

  -- If the file exists, open it
  if vim.fn.filereadable(file_path) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(file_path))
  else
    vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
  end
end

return M
