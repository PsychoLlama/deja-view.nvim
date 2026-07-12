local deja_view = require('deja-view')
local memory = require('deja-view._.memory')

--- Create a file on disk with the given number of lines.
--- @param lines integer
--- @return string path
local function create_file(lines)
  local path = vim.fn.tempname()
  local contents = {}

  for index = 1, lines do
    table.insert(contents, 'line ' .. index)
  end

  vim.fn.writefile(contents, path)
  return path
end

describe('deja-view', function()
  before_each(function()
    vim.g.deja_view_mode = 'memory'
    memory.clear()
    vim.cmd.enew()
  end)

  after_each(function()
    vim.g.deja_view_mode = nil
    vim.cmd('%bwipeout!')
  end)

  it('saves and restores views across buffer loads', function()
    deja_view.setup({ save_dir = vim.fn.tempname() })
    vim.g.deja_view_mode = 'disk'

    local path = create_file(100)
    vim.cmd.edit(path)
    vim.fn.winrestview({ lnum = 50, col = 3, topline = 40 })

    deja_view.save()
    local saved = vim.fn.winsaveview()

    vim.cmd('bwipeout!')
    vim.cmd.edit(path)
    deja_view.restore()

    assert.are.same(saved, vim.fn.winsaveview())

    vim.fn.delete(path)
    deja_view.setup(nil)
  end)

  it('ignores views that are out of bounds', function()
    local path = create_file(5)
    vim.cmd.edit(path)
    memory.write(path, { lnum = 50, col = 0, topline = 40 })

    deja_view.restore()

    assert.are.equal(1, vim.fn.winsaveview().lnum)
    vim.fn.delete(path)
  end)

  it('ignores views that disagree with the last cursor position', function()
    local path = create_file(100)
    vim.cmd.edit(path)
    vim.api.nvim_buf_set_mark(0, '"', 80, 4, {})
    memory.write(
      path,
      vim.tbl_extend('force', vim.fn.winsaveview(), {
        lnum = 20,
        col = 2,
        topline = 15,
      })
    )

    deja_view.restore()

    assert.are.equal(1, vim.fn.winsaveview().lnum)
    vim.fn.delete(path)
  end)

  it('trusts views that agree with the last cursor position', function()
    local path = create_file(100)
    vim.cmd.edit(path)
    vim.api.nvim_buf_set_mark(0, '"', 20, 2, {})
    memory.write(
      path,
      vim.tbl_extend('force', vim.fn.winsaveview(), {
        lnum = 20,
        col = 2,
        topline = 15,
      })
    )

    deja_view.restore()

    assert.are.equal(20, vim.fn.winsaveview().lnum)
    vim.fn.delete(path)
  end)

  it('does nothing for unnamed buffers', function()
    deja_view.save()
    deja_view.restore()

    assert.is_nil(memory.read(''))
  end)
end)
