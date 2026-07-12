--- In-memory backend. Useful for virtual buffers, like help pages, man
--- pages, scratch files, file browsers, etc.
local M = {}

--- @type table<string, dejaview.View>
local views = {}

--- @param path string Absolute path of the original file.
--- @param view dejaview.View
function M.write(path, view)
  views[path] = view
end

--- @param path string Absolute path of the original file.
--- @return dejaview.View|nil
function M.read(path)
  return views[path]
end

function M.clear()
  views = {}
end

return M
