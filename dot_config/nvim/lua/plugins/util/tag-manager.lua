-- manage tags in md files
local M = {}

M.tags_file = vim.fn.expand("~/.local/share/chezmoi/dot_config/nvim/tags.txt") -- overwrite directly to chezmoi dir
-- M.tags_file = vim.fn.expand("~/.config/nvim/tags.txt") -- old dir
M.tags_cache = nil -- Cache

-- Function to read tags from file
function M.get_tags()
  if M.tags_cache then
    return M.tags_cache
  end

  local tags = {}
  local unique_tags = {}

  if vim.fn.filereadable(M.tags_file) == 1 then
    for _, tag in ipairs(vim.fn.readfile(M.tags_file)) do
      local clean_tag = tag:match("^%s*(%S+)%s*$") -- Trim whitespace
      if clean_tag and not unique_tags[clean_tag] then
        unique_tags[clean_tag] = true
        table.insert(tags, clean_tag)
      end
    end
  end

  M.tags_cache = tags
  return tags
end

-- Function to create new tags
function M.create_new_tags()
  local tags = M.get_tags() -- Fetch existing tags

  -- Show input prompt to enter new tags
  vim.ui.input({
    prompt = "Enter new tag(s) (use comma ',' to separate, no spaces allowed): ",
  }, function(input)
    if not input or input == "" then
      return
    end

    -- Process input: replace spaces with underscores & split by comma
    local new_tags = {}
    for tag in input:gmatch("[^,]+") do
      tag = tag:gsub("%s+", "_") -- Convert spaces to underscores
      if not vim.tbl_contains(tags, tag) then
        table.insert(new_tags, tag)
      end
    end

    if #new_tags == 0 then
      vim.notify("No new unique tags to add", vim.log.levels.WARN)
      return
    end

    -- Append new tags to file
    local file = io.open(M.tags_file, "a")
    if file then
      for _, tag in ipairs(new_tags) do
        file:write(tag .. "\n")
      end
      file:close()
    end

    -- Update cache
    vim.list_extend(tags, new_tags)
    M.tags_cache = tags

    vim.notify("Added new tag(s): " .. table.concat(new_tags, ", "), vim.log.levels.INFO)
  end)
end

function M.remove_tags()
  local tags = M.get_tags()
  if not tags or #tags == 0 then
    vim.notify("No tags available to remove", vim.log.levels.WARN)
    return
  end

  M.show_tags_picker(function(selected_tags)
    if not selected_tags or #selected_tags == 0 then
      vim.notify("No tags selected for removal", vim.log.levels.INFO)
      return
    end

    -- Remove selected tags from cache
    local tag_set = {}
    for _, tag in ipairs(selected_tags) do
      tag_set[tag] = true
    end

    local new_tags = {}
    for _, tag in ipairs(tags) do
      if not tag_set[tag] then
        table.insert(new_tags, tag)
      end
    end
    M.tags_cache = new_tags

    -- Write updated tags to file
    local file = io.open(M.tags_file, "w")
    if file then
      for _, tag in ipairs(new_tags) do
        file:write(tag .. "\n")
      end
      file:close()
    end

    vim.notify("Removed tag(s): " .. table.concat(selected_tags, ", "), vim.log.levels.INFO)
  end, {
    prompt = "Select tags to remove:",
    multi_select = true,
    format_item = function(item)
      return "❌ " .. item
    end,
  })
end

-- NOTE: working snacks. picker but multi-select is not working.
-- function M.show_tags_picker(callback, multi_select)
--   local tags = M.get_tags()
--   if not tags or #tags == 0 then
--     vim.notify("No tags available", vim.log.levels.WARN)
--     return
--   end

--   require("snacks.picker").select(tags, {
--     prompt = "Select tag(s):",
--     format_item = function(item)
--       return "📌 " .. item
--     end,
--     multi = multi_select, -- enable multi-select
--   }, function(choices, idx)
--     if choices then
--       local selected_tags = type(choices) == "table" and choices or { choices }
--       vim.notify("Selected tags: " .. table.concat(selected_tags, ", "))
--       if callback then
--         callback(selected_tags)
--       end
--     end
--   end)
-- end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")

function M.show_tags_picker(callback)
  local tags = M.get_tags()
  if not tags or #tags == 0 then
    vim.notify("No tags available", vim.log.levels.WARN)
    return
  end

  pickers
    .new({}, {
      prompt_title = "Select tag(s):",
      finder = finders.new_table({
        results = tags,
        entry_maker = function(tag)
          return {
            value = tag,
            display = "📌 " .. tag,
            ordinal = tag,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local function select_tags()
          local selected_tags = {}
          -- Use Telescope's map_selections to gather multi selections
          action_utils.map_selections(prompt_bufnr, function(entry, _)
            table.insert(selected_tags, entry.value)
          end)
          -- If no multi selections, fallback to the current highlighted entry.
          if #selected_tags == 0 then
            local entry = action_state.get_selected_entry()
            if entry then
              table.insert(selected_tags, entry.value)
            end
          end

          if #selected_tags > 0 then
            vim.notify("Selected tags: " .. table.concat(selected_tags, ", "))
            if callback then
              callback(selected_tags)
            end
          end
          actions.close(prompt_bufnr)
        end

        map("i", "<CR>", select_tags)
        map("n", "<CR>", select_tags)
        return true
      end,
    })
    :find()
end

-- TODO: the multi-select is working now but uses telescope instead of snacks.picker. find out how to do the same with snacks.picker.
function M.append_tags_to_front_matter()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find the front matter boundaries (lines exactly '---')
  local fm_start, fm_end = nil, nil
  for i, line in ipairs(lines) do
    if line:match("^%-%-%-$") then
      if not fm_start then
        fm_start = i
      else
        fm_end = i
        break
      end
    end
  end

  if not fm_start or not fm_end then
    vim.notify("No proper front matter found", vim.log.levels.WARN)
    return
  end

  -- Find the "tags:" key inside the front matter
  local tags_line_index = nil
  for i = fm_start + 1, fm_end - 1 do
    if lines[i]:match("^tags:%s*$") then
      tags_line_index = i
      break
    end
  end

  if not tags_line_index then
    vim.notify("No tags section found in front matter", vim.log.levels.WARN)
    return
  end

  -- Determine the end of the tags block
  local tag_block_end = tags_line_index
  for i = tags_line_index + 1, fm_end - 1 do
    if lines[i]:match("^%s*%-+%s*#%S+") then
      tag_block_end = i
    else
      break
    end
  end

  -- New tags should be inserted just after the last existing tag line
  local insertion_index = tag_block_end + 1
  if insertion_index >= fm_end then
    insertion_index = fm_end -- insert before the closing '---'
  end

  -- Collect existing tags to avoid duplicates
  local existing_tags = {}
  for i = tags_line_index + 1, tag_block_end do
    local tag = lines[i]:match("^%s*%-+%s*#(%S+)")
    if tag then
      existing_tags[tag] = true
    end
  end

  -- Call the picker with multi-select enabled
  M.show_tags_picker(function(selected_tags)
    if not selected_tags or #selected_tags == 0 then
      vim.notify("No tags selected", vim.log.levels.INFO)
      return
    end

    local new_lines = {}
    for _, tag in ipairs(selected_tags) do
      if not existing_tags[tag] then
        table.insert(new_lines, "  -  #" .. tag)
        existing_tags[tag] = true
      end
    end

    if #new_lines == 0 then
      vim.notify("No new unique tags to add", vim.log.levels.WARN)
      return
    end

    -- Convert insertion index to 0-based for API call
    local api_insertion_index = insertion_index - 1
    vim.api.nvim_buf_set_lines(bufnr, api_insertion_index, api_insertion_index, false, new_lines)
    vim.notify("Added new tag(s): " .. table.concat(new_lines, ", "), vim.log.levels.INFO)
  end)
end

function M.remove_tags_from_front_matter()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find front matter boundaries
  local fm_start, fm_end = nil, nil
  for i, line in ipairs(lines) do
    if line:match("^%-%-%-$") then
      if not fm_start then
        fm_start = i
      else
        fm_end = i
        break
      end
    end
  end

  if not fm_start or not fm_end then
    vim.notify("No proper front matter found", vim.log.levels.WARN)
    return
  end

  -- Find tags block
  local tags_line_index = nil
  for i = fm_start + 1, fm_end - 1 do
    if lines[i]:match("^tags:%s*$") then
      tags_line_index = i
      break
    end
  end

  if not tags_line_index then
    vim.notify("No tags section found in front matter", vim.log.levels.WARN)
    return
  end

  -- Collect existing tags and store their line indices
  local tag_lines = {}
  local tag_indices = {}
  for i = tags_line_index + 1, fm_end - 1 do
    local tag = lines[i]:match("^%s*%-+%s*(#%S+)")
    if tag then
      table.insert(tag_lines, tag)
      tag_indices[tag] = i
    else
      break
    end
  end

  if #tag_lines == 0 then
    vim.notify("No tags to remove", vim.log.levels.WARN)
    return
  end

  -- Open Telescope picker to select tags to remove
  pickers
    .new({}, {
      prompt_title = "Select tag(s) to remove:",
      finder = finders.new_table({
        results = tag_lines,
        entry_maker = function(tag)
          return {
            value = tag,
            display = "❌ " .. tag,
            ordinal = tag,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local function remove_selected_tags()
          local selected_tags = {}
          action_utils.map_selections(prompt_bufnr, function(entry, _)
            table.insert(selected_tags, entry.value)
          end)

          if #selected_tags == 0 then
            local entry = action_state.get_selected_entry()
            if entry then
              table.insert(selected_tags, entry.value)
            end
          end

          if #selected_tags > 0 then
            -- Create a new filtered list without the selected tags
            local updated_lines = {}
            for i, line in ipairs(lines) do
              local tag = line:match("^%s*%-+%s*(#%S+)")
              if tag and vim.tbl_contains(selected_tags, tag) then
                -- Skip removing tag
              else
                table.insert(updated_lines, line)
              end
            end

            -- Update the buffer with modified lines
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, updated_lines)
            vim.notify("Removed tag(s): " .. table.concat(selected_tags, ", "), vim.log.levels.INFO)
          end

          actions.close(prompt_bufnr)
        end

        map("i", "<CR>", remove_selected_tags)
        map("n", "<CR>", remove_selected_tags)
        return true
      end,
    })
    :find()
end

-- Function to rename a tag in cache and text file
function M.rename_tag()
  M.show_tags_picker(function(selected_tags)
    if not selected_tags or #selected_tags == 0 then
      vim.notify("No tags selected", vim.log.levels.WARN)
      return
    end

    -- Use the first selected tag as the default value in the prompt
    local default_tag = selected_tags[1] or ""
    local new_tag = vim.fn.input("Rename tag '" .. default_tag .. "' to: ", default_tag)

    if new_tag == "" then
      vim.notify("No new tag name entered", vim.log.levels.WARN)
      return
    end

    -- Format the new tag
    new_tag = new_tag:gsub("%s+", "_") -- Replace spaces with underscores

    -- Check for duplication in cache
    if M.tags_cache then
      for _, tag in ipairs(M.tags_cache) do
        if tag == new_tag then
          vim.notify("Tag '" .. new_tag .. "' already exists. Rename canceled.", vim.log.levels.WARN)
          return
        end
      end
    end

    -- Read existing tags from file
    local file = io.open(M.tags_file, "r")
    if not file then
      vim.notify("Failed to open tags file", vim.log.levels.ERROR)
      return
    end
    local lines = {}
    for line in file:lines() do
      table.insert(lines, line)
    end
    file:close()

    -- Update tags while preventing duplication
    local updated = false
    for i, tag in ipairs(lines) do
      if tag == default_tag then
        lines[i] = new_tag
        updated = true
      end
    end

    if not updated then
      vim.notify("No changes made", vim.log.levels.WARN)
      return
    end

    -- Write updated tags back to file
    local file_write = io.open(M.tags_file, "w")
    if not file_write then
      vim.notify("Failed to write to tags file", vim.log.levels.ERROR)
      return
    end
    file_write:write(table.concat(lines, "\n") .. "\n")
    file_write:close()

    -- Update cache
    M.tags_cache = lines

    vim.notify("Tag renamed successfully: " .. default_tag .. " → " .. new_tag)
  end)
end

-- Autoload on first .md file open (for caching)
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.md",
  once = true,
  callback = function()
    vim.defer_fn(function()
      M.get_tags() -- Cache in the background
    end, 100)
  end,
})

return M
