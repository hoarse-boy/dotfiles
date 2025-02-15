-- all related util function to find files
local M = {}

-- Change directory and launch fzf-lua's or telescope file picker in that directory.
function M.change_dir_and_find_files(directory)
  -- TODO: update this to code to not change the working dir. this is needed to be able to open notes when opening other projects.
  -- this for now, makes harpoon to change dir though
  -- or create a autocmd to save current dir and save it in a variable.
  -- create a keybind to fetch that value from the variable and change the dir to the previous one.
  vim.fn.chdir(directory) -- this is needed to globally change the dir

  local ok, fzflua = pcall(require, "fzf-lua")
  if ok then
    fzflua.files()
  else
    require("telescope.builtin").find_files()
  end
end

--- Change directory and search for files using ripgrep
---@param directory string The directory to search in
function M.change_dir_and_live_grep(directory)
  vim.fn.chdir(directory) -- Change the global working directory

  local ok, fzflua = pcall(require, "fzf-lua")
  if ok then
    fzflua.live_grep({ cwd = directory })
  else
    require("telescope.builtin").live_grep({ cwd = directory })
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
