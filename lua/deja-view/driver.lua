--- Chooses a storage backend depending on the type of buffer.
local M = {}

--- Discards writes and never remembers anything.
--- @type dejaview.Driver
local null_driver = {
  read = function()
    return nil
  end,
  write = function() end,
}

--- The default driver selector. Persists real files to disk and refuses to
--- remember buffers whose path is reused or transient.
--- @param bufnr integer
--- @return dejaview.Driver|nil
function M.default(bufnr)
  -- Commit messages live at the same path every time and terminal buffers
  -- are transient. Remembering their views is never right.
  if
    vim.bo[bufnr].filetype == 'gitcommit'
    or vim.bo[bufnr].buftype == 'terminal'
  then
    return nil
  end

  return require('deja-view.disk')
end

--- Load the storage driver for a buffer.
--- @param bufnr? integer Defaults to the current buffer.
--- @return dejaview.Driver
function M.load(bufnr)
  local select_driver = require('deja-view.config').get_config().driver
  return select_driver(bufnr or 0) or null_driver
end

return M

--- Where and how views get stored.
--- @class dejaview.Driver
--- @field read fun(path: string): dejaview.View|nil
--- @field write fun(path: string, view: dejaview.View)

--- Decides which driver, if any, remembers a buffer's view. Returning `nil`
--- means the buffer is never remembered.
--- @alias dejaview.DriverSelector fun(bufnr: integer): dejaview.Driver|nil

--- The saved window state. Structure comes from |winsaveview()|. Partial
--- views are allowed because |winrestview()| accepts them.
--- @alias dejaview.View vim.fn.winrestview.dict
