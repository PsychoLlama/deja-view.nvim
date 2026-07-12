local M = {}

--- @return dejaview.Config
local function get_defaults()
  return {
    save_dir = vim.fs.joinpath(
      vim.fn.stdpath('state') --[[@as string]],
      'deja-view'
    ),
    driver = require('deja-view.driver').default,
  }
end

--- @type dejaview.Config
local config = get_defaults()

--- Replace the config with user-defined values merged over the defaults.
--- May be called multiple times.
--- @param user_config? dejaview.UserConfig
function M.set_config(user_config)
  config = vim.tbl_deep_extend('force', get_defaults(), user_config or {})
end

--- Get the current config.
--- @return dejaview.Config
function M.get_config()
  return config
end

return M

--- User-defined config for the plugin. All fields are optional.
--- @class dejaview.UserConfig
---
--- Directory where views are persisted. Defaults to `deja-view/` under
--- |stdpath('state')|.
--- @field save_dir? string
---
--- Picks which driver, if any, remembers a buffer's view. Receives the
--- buffer number and returns a driver, or `nil` to never remember it.
--- Defaults to persisting real files to disk while skipping commit messages
--- and terminals.
--- @field driver? dejaview.DriverSelector

--- Normalized config.
--- @class dejaview.Config
--- @field save_dir string
--- @field driver dejaview.DriverSelector
