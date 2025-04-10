-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local printf = require("plugins.util.printf").printf

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

augroup("mygroup", { clear = true })

augroup(printf("IgnoreHelpFileType"), { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "~/.config/nvim/doc/*.txt",
  callback = function()
    vim.bo.filetype = "plain"
  end,
})

-- lazyvim created autocmds to enable spell check for markdown files. this is to disable it.
local disable_spell_group = augroup("disable_spell", { clear = true })
autocmd("FileType", {
  group = disable_spell_group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- options.lua is not working. this is a workaround.
-- opt.wrap = false
-- vim.wo.wrap = false
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- for indentation. currently, makes my fish code to have 4 tabs instead of 2.
-- opt.shiftwidth = 4 -- this is to make indentation work properly.
-- opt.tabstop = 4 -- Tabs are displayed as 4 spaces even when it is not. if the actual tab width is 4, it will be displayed the same.
-- NOTE: to make it simple.
-- if the file has 4 spaces,
-- go to its own plugin file and copy the autcmd below
-- else add that to the lua table below in 'pattern'.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fish" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    -- vim.bo.softtabstop = 4
  end,
})

-- NOTE: disable this in favor of the yanky plugin
-- -- make yank animation to be blazingly fast
-- local yank_group = augroup("HighlightYank", {})
-- autocmd("TextYankPost", {
--   group = yank_group,
--   pattern = "*",
--   callback = function()
--     vim.highlight.on_yank({
--       higroup = "IncSearch",
--       timeout = 10, -- yank latency
--     })
--   end,
-- })

-- disable auto add comment to a new line.
-- autocmd("Filetype", {
--   pattern = { "*" },
--   callback = function()
--     -- vim.opt.formatoptions = vim.opt.formatoptions - "o"
--     if vim.bo["ft"] == "css" then
--       vim.opt_local.formatoptions:remove("r") -- don't enter comment leader on Enter in css files
--     end
--     vim.opt.formatoptions = vim.opt.formatoptions + {
--       o = false, -- Don't continue comments with o and O
--       r = false, -- don't insert comment leader on Enter
--     }
--   end,
--   group = "mygroup",
--   desc = printf"Don't continue comments with o, O, and enter",
-- })

-- -- Log the time before quitting
-- local start_time
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     start_time = vim.fn.reltime()
--   end
-- })

-- -- Log the time after quitting and calculate the duration
-- vim.api.nvim_create_autocmd("VimLeave", {
--   callback = function()
--     local end_time = vim.fn.reltime()
--     local elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time, end_time))
--     -- Ensure the time string is clean and properly formatted
--     elapsed_time = string.gsub(elapsed_time, "%z", "") -- Remove null character if present
--     -- Use the home directory for logging
--     local log_file = vim.fn.expand("~") .. "/nvim_quit_time.log"
--     local log_message = "Quit time: " .. elapsed_time .. "\n"
--     vim.fn.writefile({log_message}, log_file, "a")
--   end
-- })
