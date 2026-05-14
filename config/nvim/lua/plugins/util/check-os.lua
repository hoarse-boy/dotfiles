-- --  /user.getOS.lua
-- local getOS = {}

-- function getOS.get_os_name()
--   local osname
--   -- ask LuaJIT first
--   if jit then
--     return jit.os
--   end

--   -- Unix, Linux variants
--   local fh, _ = assert(io.popen("uname -o 2>/dev/null", "r"))
--   if fh then
--     osname = fh:read()
--   end

--   return osname or "Windows"
-- end

-- -- const
-- getOS.OSX = "OSX"
-- getOS.LINUX = "Linux"
-- -- TODO: add more OS const

-- return getOS

local getOS = {}

getOS.OSX = "OSX"
getOS.LINUX = "Linux"

-- Internal cache (nil = not known yet)
local cached_os_name

-- Public API
function getOS.get_os_name()
  -- fast path: already known
  if cached_os_name then
    return cached_os_name
  end

  if jit then
    cached_os_name = jit.os
    return cached_os_name
  end

  local fh = io.popen("uname -o 2>/dev/null")
  if fh then
    cached_os_name = (fh:read("*a") or ""):match("^%s*(.-)%s*$")
    fh:close()
  end

  cached_os_name = cached_os_name or "Windows"
  return cached_os_name
end

return getOS
