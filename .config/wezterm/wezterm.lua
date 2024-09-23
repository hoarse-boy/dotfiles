local wezterm = require("wezterm")
local act = wezterm.action

local is_macos = wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin"

local font_size = 10
if is_macos then
  font_size = 15.0
end

local function copyAll(win, pane) -- copy all text in a pane (except for bottom prompt in Xonsh)
  local prompt_bottom_offset = 0
  local proc = pane:get_foreground_process_info()
  local name, binpath, arg = proc.name, proc.executable, proc.argv
  local isXonsh = sh.isXonsh(arg)
  if isXonsh then
    if os.getenv("BOTTOM_TOOLBAR") then
      prompt_bottom_offset = 2 -- exclude the main + bottom prompts
    else
      prompt_bottom_offset = 1 -- exclude the main          prompt
    end
  end

  local dims = pane:get_dimensions()
  local txt = pane:get_text_from_region(
    0,
    dims.scrollback_top,
    0,
    dims.scrollback_top + dims.scrollback_rows - prompt_bottom_offset
  )
  win:copy_to_clipboard(txt:match("^%s*(.-)%s*$")) -- trim leading and trailing whitespace
end

-- -- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- -- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- TODO: make it modular.
return {
  -- NOTE: sometime performance is kinda bad. holding j or k and typing and snippet will have delay that is noticable. if it happen try to close and open wezterm again.
  -- if it persist, just try abduco or other package.
  -- NOTE: still be using it but in manual way. why manual? it is to open regular wezterm instance incase i need tiling window of many wezterm instance.
  -- and also, if i want to quicly run or open some comamnds and exit.
  -- default_gui_startup_args = { "connect", "unix" },
  -- MARKED: remove this comments as i have used tmux.
  -- term = "wezterm", -- NOTE: undercurl / to make nvim have single color underline => https://wezfurlong.org/wezterm/config/lua/config/term.html?h=undercur
  adjust_window_size_when_changing_font_size = false,
  audible_bell = "Disabled",
  underline_thickness = 0,
  exit_behavior = "Close",
  max_fps = 75,
  font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium", stretch = "Normal", style = "Normal" }),
  font_size = font_size, -- the best for my nvim
  force_reverse_video_cursor = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,

  -- Set the maximum width of the tabs in pixels
  tab_max_width = 20, -- Adjust this value to your preference

  -- show_tabs_in_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  -- FIX: modify and fix the ugly tab bar.

  -- window_background_opacity = 0.9,
  window_background_opacity = 0.87,
  -- text_background_opacity = 0.8, -- dont use this as it will make the todo comments to have less visibility.
  colors = {
    tab_bar = {
      -- background = "rgba(0,0,0,0)",
      -- active_tab = {
      --        bg_color = "#1E1E2E",
      --        fg_color = "#FFFFFF",
      --        intensity = "Bold",
      --        -- underline = "Single",
      --      },
      --      inactive_tab = {
      --        bg_color = "#1E1E2E",
      --        fg_color = "#AAAAAA",
      --      },
      --      inactive_tab_hover = {
      --        bg_color = "#3E3E4E",
      --        fg_color = "#FFFFFF",
      --      },
      --      new_tab = {
      --        bg_color = "#1E1E2E",
      --        fg_color = "#FFFFFF",
      --      },
    },
  },

  -- https://wezfurlong.org/wezterm/config/default-keys.html
  disable_default_key_bindings = false,
  keys = {
    { key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    -- { key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) }, -- accidently closing tab in wezterm sessin will delete it forever. -- NOTE: this keymap is used by supermaven
    { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },               -- linux uses ctlr c to stop command in terminal.
    { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },            -- default nvim uses ctlr 'v' to do v-block mode.
    {
      key = "n",
      mods = "SHIFT|CTRL",
      action = wezterm.action.ToggleFullScreen,
    },
    -- remove prompt when closing the tab
    {
      key = "w",
      mods = "CMD",
      action = wezterm.action.CloseCurrentPane({ confirm = false }),
    },
  },

  scrollback_lines = 10000,
  -- show_update_window = true,
  use_dead_keys = false,
  unicode_version = 14,
  window_close_confirmation = "NeverPrompt",
  window_padding = {
    -- left = "0.5cell",
    left = "1.0cell",
    right = 0,
    -- right = 0,
    top = "0.5cell", -- hyprland makes the upper part of the terminal to be missing, so it needs space.
    bottom = "0.2cell",
  },
}
