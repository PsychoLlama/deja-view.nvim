local config = require('deja-view._.config')
local disk = require('deja-view._.disk')

describe('disk', function()
  before_each(function()
    config.set_config({ save_dir = vim.fn.tempname() })
  end)

  after_each(function()
    vim.fn.delete(config.get_config().save_dir, 'rf')
    config.set_config(nil)
  end)

  describe('get_path', function()
    it('flattens paths into the save directory', function()
      assert.are.equal(
        vim.fs.joinpath(config.get_config().save_dir, '%path%to%file.txt'),
        disk.get_path('/path/to/file.txt')
      )
    end)

    it('escapes literal percent signs', function()
      assert.are.equal(
        vim.fs.joinpath(config.get_config().save_dir, '%100%%'),
        disk.get_path('/100%')
      )
    end)
  end)

  it('round-trips a view through the file system', function()
    local view = { lnum = 10, col = 2, topline = 5 }
    disk.write('/path/to/file.txt', view)

    assert.are.same(view, disk.read('/path/to/file.txt'))
  end)

  it('returns nil for unknown files', function()
    assert.is_nil(disk.read('/never/saved.txt'))
  end)

  it('returns nil for corrupt storage files', function()
    disk.write('/path/to/file.txt', { lnum = 1 })
    vim.fn.writefile({ 'not json' }, disk.get_path('/path/to/file.txt'))

    assert.is_nil(disk.read('/path/to/file.txt'))
  end)
end)
