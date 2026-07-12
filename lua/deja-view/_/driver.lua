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

--- Figure out which save mode applies to a buffer. Buffer-local settings
--- take priority over globals.
--- @param bufnr integer
--- @return string
local function get_save_mode(bufnr)
  -- Commit messages live at the same path every time and terminal buffers
  -- are transient. Remembering their views is never right.
  if
    vim.bo[bufnr].filetype == 'gitcommit'
    or vim.bo[bufnr].buftype == 'terminal'
  then
    return 'none'
  end

  local mode = vim.b[bufnr].deja_view_mode or vim.g.deja_view_mode or 'disk'
  return mode
end

--- Load the storage driver for a buffer.
--- @param bufnr? integer Defaults to the current buffer.
--- @return dejaview.Driver
function M.load(bufnr)
  local mode = get_save_mode(bufnr or 0)

  if mode == 'disk' then
    return require('deja-view._.disk')
  end

  if mode == 'none' then
    return null_driver
  end

  if mode ~= 'memory' then
    vim.notify_once(
      string.format(
        '[deja-view] Unknown save mode "%s". Falling back to "memory".',
        mode
      ),
      vim.log.levels.ERROR
    )
  end

  return require('deja-view._.memory')
end

return M

--- Where and how views get stored.
--- @class dejaview.Driver
--- @field read fun(path: string): dejaview.View|nil
--- @field write fun(path: string, view: dejaview.View)

--- The saved window state. Structure comes from |winsaveview()|. Partial
--- views are allowed because |winrestview()| accepts them.
--- @alias dejaview.View vim.fn.winrestview.dict
