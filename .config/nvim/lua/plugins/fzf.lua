-- don't remove this code. uses snacks.nvim picker instead.
return {
  "ibhagwan/fzf-lua",
  enabled = false,
  cmd = "FzfLua",
  opts = function(_, opts)
    local config = require("fzf-lua.config")

    -- config.defaults.keymap.fzf["ctrl-z"] = "abort"
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-x"] = "unix-line-discard"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-s"] = "jump"
    config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
    config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
    config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
    config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

    -- vim.cmd[[hi link FzfLuaCursorLine NONE]] -- TODO: change the higlight on the left side when opening fzf lua

    opts.file_ignore_patterns = { "node_modules", "vendor", "proto/*", "**/*.pb.go" } -- fzf global ignore
  end,
  keys = {
    { "<leader>/", false }, -- NOTE: remove live grep keybinding
  },
}
