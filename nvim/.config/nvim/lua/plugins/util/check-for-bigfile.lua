local M = {}

function M.is_bigfile()
  local ok, stats = pcall(vim.loop.fs_stat, vim.fn.expand("%:p"))
  if ok and stats and stats.size > (1.5 * 1024 * 1024) then -- > 1.5MB
    return true
  end
  return false
end

return M
