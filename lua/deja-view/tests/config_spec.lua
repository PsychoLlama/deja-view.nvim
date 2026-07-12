local config = require('deja-view.config')
local driver = require('deja-view.driver')

describe('config', function()
  after_each(function()
    config.set_config(nil)
  end)

  it('defaults to a directory under stdpath("state")', function()
    assert.are.equal(
      vim.fs.joinpath(vim.fn.stdpath('state'), 'deja-view'),
      config.get_config().save_dir
    )
  end)

  it('accepts a custom save directory', function()
    config.set_config({ save_dir = '/tmp/custom-views' })

    assert.are.equal('/tmp/custom-views', config.get_config().save_dir)
  end)

  it('restores defaults when settings are omitted', function()
    config.set_config({ save_dir = '/tmp/custom-views' })
    config.set_config({})

    assert.are.equal(
      vim.fs.joinpath(vim.fn.stdpath('state'), 'deja-view'),
      config.get_config().save_dir
    )
  end)

  it('defaults the driver selector to the built-in', function()
    assert.are.equal(driver.default, config.get_config().driver)
  end)

  it('accepts a custom driver selector', function()
    local select_driver = function() end
    config.set_config({ driver = select_driver })

    assert.are.equal(select_driver, config.get_config().driver)
  end)
end)
