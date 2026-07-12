local M = {}

--- Configure the plugin. Optional; the plugin works without it.
--- @param config? dejaview.UserConfig
function M.setup(config)
  require('deja-view._.config').set_config(config)
end

--- Save the current window's view.
function M.save()
  local path = vim.api.nvim_buf_get_name(0)

  if path == '' then
    return
  end

  local driver = require('deja-view._.driver').load()
  driver.write(path, vim.fn.winsaveview())
end

--- Restore the current window's view from a previous session.
function M.restore()
  local path = vim.api.nvim_buf_get_name(0)

  if path == '' then
    return
  end

  local view = require('deja-view._.driver').load().read(path)

  -- If the remembered line number is out of bounds, it's probably wrong.
  if view == nil or view.lnum > vim.api.nvim_buf_line_count(0) then
    return
  end

  -- Vim automatically remembers your last cursor position (but not your
  -- view, which is why the plugin exists). The line/column memory is more
  -- accurate than we can achieve through autocommands. Use it as a sanity
  -- check.
  --
  -- Running `:edit` on the same buffer reloads it, but since there's no
  -- event for deja-view to detect and save the view, we lose information
  -- and incorrectly load the old one instead. Since the cursor position
  -- doesn't change by `:edit`, we can simply ignore the event.
  local last_line, last_col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
  if last_line > 1 and last_col > 0 then
    if last_line ~= view.lnum and last_col ~= view.col then
      return
    end
  end

  vim.fn.winrestview(view)
end

return M
