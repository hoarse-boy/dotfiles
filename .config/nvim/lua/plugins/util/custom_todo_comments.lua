local M = {}

-- Define comment symbols for various filetypes
local filetype_formats = {
  javascript = "// %s",
  typescript = "// %s",
  json = "// %s",
  jsonc = "// %s",
  java = "// %s",
  c = "// %s",
  go = "// %s",
  rust = "// %s",
  php = "// %s",
  cpp = "// %s",
  sh = "# %s",
  bash = "# %s",
  yaml = "# %s",
  perl = "# %s",
  ruby = "# %s",
  conf = "# %s",
  hyprlang = "# %s",
  python = "# %s",
  mojo = "# %s",
  html = "<!-- %s -->",
  markdown = "<!-- %s -->", -- value with `priority` as it mostly used in my markdown notes.
  -- markdown = "<!-- %s --> priority", -- value with `priority` as it mostly used in my markdown notes. -- FIX:
  lua = "-- %s",
  css = "/* %s */",
}

-- define a local function to insert a todo comment keyword line and enter insert mode.
function M.insert_custom_todo_comments(keyword_str)
  if keyword_str == nil then
    keyword_str = "MARKED: " -- default.
  end

  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()
  -- Get the current line number
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  -- Get the file type of the current buffer using vim.bo
  local filetype = vim.bo[bufnr].filetype

  -- Get the comment symbol for the current filetype
  local comment_symbol = filetype_formats[filetype]

  -- Handle cases where the file type isn't in the list
  if comment_symbol == nil then
    print("Filetype " .. filetype .. " is not supported. manually add it to the comment_symbols in insert_custom_todo_comments.lua in util folder.")
    comment_symbol = "%s"
  end

  -- Format the commented string
  local fmt_keyword = string.format(comment_symbol, keyword_str)

  -- Check if the current line is empty before inserting the custom keyword line
  local current_line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]
  if current_line == nil or current_line:match("^%s*$") then
    -- If current line is empty, insert the custom keyword line directly
    vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { fmt_keyword })
  else
    -- If current line is not empty, insert the custom keyword line above and adjust current line position
    vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr - 1, false, { fmt_keyword })
  end

  -- Move cursor to the end of the custom keyword line and enter insert mode
  vim.api.nvim_win_set_cursor(0, { linenr, #fmt_keyword })

  -- Enter insert mode
  vim.cmd("startinsert!")
end

-- TODO: add  bool in params, if true, go to insert mode by using vim 'A'.
-- define a local function to insert a todo comment keyword at the end of the current line.

--- @param keyword_str string | nil: the keyword to be added to the current line.
--- @param additional_str string: the additional string to be added to the current line.
--- @param is_entering_insert_mode boolean: whether to enter insert mode after adding the keyword.
function M.append_todo_comments_to_current_line(keyword_str, additional_str, is_entering_insert_mode)
  if keyword_str == nil then
    keyword_str = "FIX: . " -- default.
  end

  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()
  -- Get the current line number
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  -- Get the file type of the current buffer using vim.bo
  local filetype = vim.bo[bufnr].filetype

  -- Get the comment symbol for the current filetype
  local comment_symbol = filetype_formats[filetype]

  -- Handle cases where the file type isn't in the list
  if comment_symbol == nil then
    print("Filetype " .. filetype .. " is not supported. manually add it to the comment_symbols in insert_custom_todo_comments.lua in util folder.")
    comment_symbol = "%s"
  end

  -- Format the commented string
  local fmt_keyword = string.format(comment_symbol, keyword_str)

  -- Get the current line content
  local current_line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]

  if additional_str == "" and filetype == "markdown" then
    additional_str = "priority"
  end

  -- Append the custom keyword to the current line
  local new_line = current_line .. " " .. fmt_keyword .. additional_str

  -- Update the current line with the new content
  vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { new_line })

  if is_entering_insert_mode then
    -- Move cursor to the end of the custom keyword line and enter insert mode
    vim.api.nvim_win_set_cursor(0, { linenr, #fmt_keyword })

    -- Enter insert mode
    vim.cmd("startinsert!")
  end
end

-- FIX: old one. remove later?
-- need to create new one for current lines
-- as this has been updated
function M.remove_fix_comments_from_current_line()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local comment_symbol = filetype_formats[filetype]

  if not comment_symbol then
    print("Filetype " .. filetype .. " is not supported.")
    return
  end

  -- Generate the FIX comment string for the current filetype
  local str_tobe_removed = "FIX: ."
  if filetype == "markdown" then
    str_tobe_removed = "FIX: . "
  end
  local fix_comment = string.format(comment_symbol, str_tobe_removed)

  -- Escape special Lua pattern characters
  local pattern_comment = vim.pesc(fix_comment)

  -- Create match pattern for the entire comment and any trailing text
  -- Handles optional whitespace before/after comment and any text following
  local pattern = "%s*" .. pattern_comment .. ".*"

  -- Get current line content
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local current_line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1] or ""

  -- Remove the FIX comment and any trailing text
  local new_line = current_line:gsub(pattern, "")

  -- Update the line if changes were made
  if new_line ~= current_line then
    vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { new_line })
  end
end

-- FIX: test htis. buggy
-- check this?
-- local start_line, _ = unpack(vim.fn.getpos("'<"), 2, 3)
-- local end_line, _ = unpack(vim.fn.getpos("'>"), 2, 3)
-- local lines = vim.fn.getline(start_line, end_line)
function M.remove_fix_comments_from_current_lines()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local comment_symbol = filetype_formats[filetype]

  if not comment_symbol then
    print("Filetype " .. filetype .. " is not supported.")
    return
  end

  -- Generate the FIX comment string for the current filetype
  local fix_comment = string.format(comment_symbol, "FIX: ")
  -- Escape special Lua pattern characters
  local pattern_comment = vim.pesc(fix_comment)

  -- Create match pattern for the entire comment and any trailing text
  -- Handles optional whitespace before/after comment and any text following
  local pattern = "%s*" .. pattern_comment .. ".*"

  -- Get current mode and visual selection if in visual mode
  local mode = vim.api.nvim_get_mode().mode
  local start_line, start_col, end_line, end_col

  if mode == "V" or mode == "v" then
    -- Visual Mode: Get the start and end lines of the selection
    start_line, _ = unpack(vim.api.nvim_buf_get_mark(bufnr, "<"))
    end_line, _ = unpack(vim.api.nvim_buf_get_mark(bufnr, ">"))

    -- Ensure the lines are in the correct order (start_line < end_line)
    if start_line > end_line then
      start_line, end_line = end_line, start_line
      end_col = vim.api.nvim_win_get_cursor(0)[2] -- Get the end column (for visual block mode)
    else
      -- Normal Mode: Just operate on the current line
      start_line = vim.api.nvim_win_get_cursor(0)[1]
      end_line = start_line
    end

    -- Loop through the selected lines and remove FIX comments
    for linenr = start_line, end_line do
      local current_line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1] or ""
      local new_line = current_line:gsub(pattern, "")

      -- Update the line if changes were made
      if new_line ~= current_line then
        vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { new_line })
      end
    end
  end
end

return M
