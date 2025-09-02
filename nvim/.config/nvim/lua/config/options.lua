-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local cmd = vim.cmd

opt.fillchars = { eob = " " } -- NOTE: removes trailing '~' in nvim

cmd.highlight("CursorLine guibg=#131319") -- CursorLine    xxx guibg=#2a2b3c

-- require("config.neovide").setup()

-- opt.cursorline = true
opt.list = false -- NOTE: make the > and other symbol to be hidden when the object is commented.

-- minimal number of screen lines to keep above and below the cursor.
-- make the number lower to make image.nvim works by showing all part of the image as possible.
-- scroll using ctlr-e or y or z+enter
opt.scrolloff = 4
-- opt.scrolloff = 12 -- minimal number of screen lines to keep above and below the cursor.
opt.sidescrolloff = 20 -- minimal number of screen lines to keep left and right of the cursor.
opt.hlsearch = true -- highlight all matches on previous search pattern.
opt.relativenumber = false
opt.backup = false
opt.undofile = true
opt.writebackup = false

vim.g.autoformat = false -- disable auto format. use <leader>cf to format.

-- NOTE: the prompt is annoying. however, it is required in case of nvim or neovide crash.
-- how to stop the prompt, choose the option 'r' or recover.
-- if there is more than one swap file, choose no. 1 which is the most recent.
-- save the file and quit or remove the buffer using <leader>bd.
-- open the file or buffer again, the swap file probably still exists.
-- choose 'd' to delete the swap file. the prompt will disappear.
opt.swapfile = true
opt.updatetime = 300 -- Set to 300 milliseconds for more frequent swap file updates

local os_util = require("plugins.util.check-os")
local os_name = os_util.get_os_name()

if os_name == os_util.LINUX then
  vim.opt.directory = "/tmp/nvim/swap//" -- NOTE: change dir as the .local/share/nvim/swap is not working on arch linux. macos works fine.
end

-- specific global variable for lazyvim features
vim.g.lazyvim_picker = "snacks" -- use snacks.nvim as the default picker without adding any extra config.
vim.g.lazyvim_prettier_needs_config = true -- makes prettier to use prettierrc.yml file in the root of the project.
-- vim.g.snacks_animate = false -- disable animations
-- vim.g.snacks_animate_scroll = false -- disable scroll animations
-- vim.g.lazyvim_cmp = "nvim-cmp" -- lazyvim 14.* reguired this if nvim-cmp is used, as blink.cmp is the default.

vim.filetype.add({
  pattern = {
    [".envrc"] = "bash",  -- Treat .envrc as bash
  },
})
