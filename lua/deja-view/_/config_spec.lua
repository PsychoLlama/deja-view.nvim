local config = require('deja-view._.config')

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
end)
