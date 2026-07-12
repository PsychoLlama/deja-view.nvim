local M = {}

--- Configure the plugin. Optional; the plugin works without it.
--- @param config? dejaview.UserConfig
function M.setup(config)
  require('deja-view.config').set_config(config)
end

--- Save the current window's view.
function M.save()
  local path = vim.api.nvim_buf_get_name(0)

  if path == '' then
    return
  end

  local driver = require('deja-view.driver').load()
  driver.write(path, vim.fn.winsaveview())
end

--- Restore the current window's view from a previous session.
function M.restore()
  local path = vim.api.nvim_buf_get_name(0)

  if path == '' then
    return
  end

  local view = require('deja-view.driver').load().read(path)

  -- If the remembered line number is out of bounds, it's probably wrong.
  if
    view == nil
    or view.lnum == nil
    or view.lnum > vim.api.nvim_buf_line_count(0)
  then
    return
  end

  vim.fn.winrestview(view)
end

return M
