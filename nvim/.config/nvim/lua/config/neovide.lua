local opt = vim.opt
local set_keymap = vim.keymap.set
local printf = require("plugins.util.printf").printf

local M = {}

M.setup = function()
  if vim.g.neovide then
    -- TODO: lualine "" and "" characters color is different in neovide. need to fix it.

    opt.guifont = "JetBrainsMono Nerd Font:h16.00:Medium" -- the font used in graphical neovim applications

    vim.g.neovide_scale_factor = 1.0
    -- stylua: ignore
    local change_scale_factor = function(delta) vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta end

    vim.g.neovide_underline_stroke_scale = 2.0 -- the same as kitty's and wezterm's underline underline modifier
    vim.g.neovide_transparency = 0.9 -- NOTE: can be used in windows too but moving neovide to new desktop in windows is not fun just to get transparency and background.
    vim.g.neovide_refresh_rate = 75
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_padding_top = 3
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 3
    vim.g.neovide_padding_left = 3
    -- NOTE: to remove the gap between lines for "|" or other characters. this also fix the lualine "" and "" characters position was a bit lower, -3 will make the position the same as nvim in wezterm.
    -- dont increase the value too much.
    vim.opt.linespace = -3

    -- enable ctlr-tab navigation for neovide only as it has no tab support
    set_keymap("n", "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = printf("Next buffer") })
    set_keymap("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = printf("Prev buffer") })

    local os_util = require("plugins.util.check-os")
    local os_name = os_util.get_os_name()

    if os_name == os_util.LINUX then
      opt.guifont = "JetBrainsMono Nerd Font:h12.5:Bold" -- the font used in graphical neovim applications
      -- opt.guifont = "JetBrainsMono Nerd Font:h12.5:Medium" -- the font used in graphical neovim applications
      -- opt.guifont = "FiraCode Nerd Font Mono:h12.15:Medium" -- the font used in graphical neovim applications

      -- stylua: ignore start
      set_keymap("n", "<C-=>", function() change_scale_factor(1.25) end)
      set_keymap("n", "<C-->", function() change_scale_factor(1 / 1.25) end)

      set_keymap("v", "<C-C>", '"+y') -- Copy
      -- NOTE: the only solution for neovide in arch linux
      set_keymap({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end, { noremap = true, silent = true })
      -- stylua: ignore end
    else
      -- stylua: ignore start
      set_keymap("n", "<D-=>", function() change_scale_factor(1.25) end)
      set_keymap("n", "<D-->", function() change_scale_factor(1 / 1.25) end)
      -- stylua: ignore end

      vim.g.neovide_input_macos_option_key_is_meta = "only_left"
      vim.g.neovide_fullscreen = 1 -- fullscreen on macos, this is needed to make it onto a new macos workspace or desktop to avoid stacking with wezterm or kitty.
      -- vim.g.neovide_input_macos_alt_is_meta = true -- for option in macos
      -- vim.g.neovide_input_use_logo = 1             -- enable use of the logo (cmd) key

      -- stylua: ignore start
      -- copy
      set_keymap("v", "<D-c>", '"+y') -- Copy

      -- paste
      set_keymap("n", "<D-s>", ":w<CR>") -- Save
      set_keymap("v", "<D-v>", '"+P') -- Paste visual mode
      set_keymap("c", "<D-v>", "<C-R>+") -- Paste command mode
      set_keymap("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
      set_keymap("n", "<D-v>", function() vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end)
      -- stylua: ignore end
    end

    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_cursor_vfx_mode = "ripple" -- wireframe, sonicboom, pixiedust, railgun
    -- vim.g.neovide_cursor_vfx_particle_curl = 1.5 -- only for railgun
    vim.g.neovide_cursor_vfx_particle_density = 25.0
    vim.g.neovide_cursor_vfx_opacity = 300.0 
    vim.g.neovide_cursor_vfx_particle_lifetime = 13.5
    vim.g.neovide_cursor_vfx_particle_speed = 100.0
  end
end

return M
