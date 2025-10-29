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
  fish = "# %s",
  python = "# %s",
  mojo = "# %s",
  html = "<!-- %s -->",
  markdown = "<!-- %s -->", -- value with `priority` as it mostly used in my markdown notes.
  lua = "-- %s",
  css = "/* %s */",
  lisp = ";; %s",
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
    additional_str = "priority. "
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

-- comment or uncomment current line.
-- if the line has the 'UNCOMMENT: .' comment, remove it and uncomment the line
-- otherwise, comment the line and append 'UNCOMMENT: .'
function M.toggle_uncomment_comment()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local comment_symbol = filetype_formats[filetype]

  if not comment_symbol then
    print("Filetype " .. filetype .. " is not supported.")
    return
  end

  local str_tobe_removed = "UNCOMMENT: . Uncomment this line later"
  local uncomment_comment = string.format(comment_symbol, str_tobe_removed)
  local pattern_comment = vim.pesc(uncomment_comment)
  local pattern = "%s*" .. pattern_comment .. ".*"

  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local current_line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1] or ""

  if current_line:match(pattern) then
    -- If the line has the 'UNCOMMENT: .' comment, remove it and uncomment the line
    local new_line = current_line:gsub(pattern, "")
    vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { new_line })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(comment_toggle_linewise_current)", true, false, true), "m", false)
  else
    -- Otherwise, comment the line and append 'UNCOMMENT: .'
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(comment_toggle_linewise_current)", true, false, true), "m", false)
    vim.defer_fn(function()
      local commented_line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1] or ""
      local updated_line = commented_line .. " " .. uncomment_comment
      vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { updated_line })
    end, 50) -- Small delay to ensure comment toggle applies first
  end
end

-- make it global so keybindings or other files can call it
function M.clean_fix_comments_in_range(line1, line2)
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local fmt = filetype_formats[filetype]

  if not fmt then
    print("unsupported filetype: " .. filetype)
    return
  end

  local str_tobe_removed = "FIX: ."
  if filetype == "markdown" then
    str_tobe_removed = "FIX: . "
  end

  local fix_comment = string.format(fmt, str_tobe_removed)
  local pattern_comment = vim.pesc(fix_comment)

  local pattern
  if filetype == "markdown" or filetype == "html" then
    pattern = "%s*" .. pattern_comment .. ".*"
  else
    pattern = "%s*" .. pattern_comment .. ".*"
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, line1 - 1, line2, false)
  local changed = false

  for i, line in ipairs(lines) do
    local new_line = line:gsub(pattern, "")
    if new_line ~= line then
      lines[i] = new_line
      changed = true
    end
  end

  if changed then
    vim.api.nvim_buf_set_lines(bufnr, line1 - 1, line2, false, lines)
    print(string.format("cleaned FIX: . from lines %d-%d", line1, line2))
  else
    print("no FIX: . found in range")
  end
end

return M
