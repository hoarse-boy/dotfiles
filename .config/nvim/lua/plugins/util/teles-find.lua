-- vim.cmd('cd ~/google-drive/obsidian-vault/todos/')
local M = {}

function M.ChangeDirAndFindFiles(directory)
  M.ChangeDir(directory)
  require("telescope.builtin").find_files({ cwd = directory }) -- Call Telescope find_files
end

-- Change the current working directory
function M.ChangeDir(directory)
  vim.cmd("cd " .. directory)
end

return M
