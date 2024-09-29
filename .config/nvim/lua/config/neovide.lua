local opt = vim.opt
local set_keymap = vim.keymap.set

local M = {}

M.setup = function()
  if vim.g.neovide then
    -- TODO: lualine "" and "" characters color is different in neovide. need to fix it.

    opt.guifont = "JetBrainsMono Nerd Font:h11.70:Medium" -- the font used in graphical neovim applications

    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set("n", "<C-=>", function()
      change_scale_factor(1.25)
    end)
    vim.keymap.set("n", "<C-->", function()
      change_scale_factor(1 / 1.25)
    end)

    vim.g.neovide_transparency = 0.9 -- NOTE: can be used in windows too but moving neovide to new desktop in windows is not fun just to get transparency and background.
    vim.g.neovide_refresh_rate = 75
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_padding_top = 3
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 3
    vim.g.neovide_padding_left = 3
    vim.opt.linespace = -2 -- NOTE: to remove the gap between lines for "|" or other characters. this also fix the lualine "" and "" characters position was a bit lower, -2 will make the position the same as nvim in wezterm.

    -- vim.g.neovide_input_macos_alt_is_meta = true -- for option in macos
    -- vim.g.neovide_input_use_logo = 1             -- enable use of the logo (cmd) key

    local os_util = require("plugins.util.check-os")
    local os_name = os_util.get_os_name()

    if os_name == os_util.LINUX then
      opt.guifont = "JetBrainsMono Nerd Font:h12.5:Bold" -- the font used in graphical neovim applications
      -- opt.guifont = "JetBrainsMono Nerd Font:h12.5:Medium" -- the font used in graphical neovim applications
      -- opt.guifont = "FiraCode Nerd Font Mono:h12.15:Medium" -- the font used in graphical neovim applications

      set_keymap("v", "<C-C>", '"+y') -- Copy
      -- NOTE: the only solution for neovide in arch linux
      vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
        vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
      end, { noremap = true, silent = true })
    else
      -- stylua: ignore
      set_keymap("n", "<c-v>", function() vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end)
      set_keymap("v", "<c-C>", '"+y') -- Copy

      -- paste
      set_keymap("n", "<D-s>", ":w<CR>") -- Save
      set_keymap("v", "<D-v>", '"+P') -- Paste visual mode
      set_keymap("c", "<D-v>", "<C-R>+") -- Paste command mode
      set_keymap("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
      -- set_keymap("n", "<c-shift-v>", '"+P') -- Paste normal mode
      -- set_keymap("n", "<D-V>", '"+P') -- Paste normal mode
    end

    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_cursor_vfx_mode = "ripple"
    -- vim.g.neovide_cursor_vfx_mode = "wireframe"
    -- vim.g.neovide_cursor_vfx_mode = "sonicboom"
    -- vim.g.neovide_cursor_vfx_mode = "pixiedust""
    -- vim.g.neovide_cursor_vfx_mode = "railgun"
    -- vim.g.neovide_cursor_vfx_particle_curl = 1.5 -- only for railgun
    vim.g.neovide_cursor_vfx_particle_density = 25.0
    vim.g.neovide_cursor_vfx_opacity = 300.0
    vim.g.neovide_cursor_vfx_particle_lifetime = 13.5
    vim.g.neovide_cursor_vfx_particle_speed = 100.0
  end
end

return M
