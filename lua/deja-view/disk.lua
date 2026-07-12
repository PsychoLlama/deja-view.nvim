--- Persist views to the file system under a user-configurable directory.
--- File names are escaped and written flat, much like vim's 'undodir'.
local M = {}

--- Turn '/path/to/file' into '%path%to%file'.
--- @param path string
--- @return string
local function escape_path(path)
  local escaped = path:gsub('%%', '%%%%'):gsub('/', '%%')
  return escaped
end

--- Get the storage file for a buffer path.
--- @param path string Absolute path of the original file.
--- @return string
function M.get_path(path)
  local config = require('deja-view.config').get_config()
  return vim.fs.joinpath(config.save_dir, escape_path(path))
end

--- @param path string Absolute path of the original file.
--- @param view dejaview.View
function M.write(path, view)
  local config = require('deja-view.config').get_config()

  -- This is fast enough that it might as well be free.
  vim.fn.mkdir(config.save_dir, 'p')

  vim.fn.writefile({ vim.json.encode(view) }, M.get_path(path))
end

--- @param path string Absolute path of the original file.
--- @return dejaview.View|nil
function M.read(path)
  local file = io.open(M.get_path(path), 'r')

  if file == nil then
    return nil
  end

  local contents = file:read('*a')
  file:close()

  local ok, view = pcall(vim.json.decode, contents)
  return ok and view or nil
end

return M
