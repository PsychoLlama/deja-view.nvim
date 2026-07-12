local config = require('deja-view.config')
local deja_view = require('deja-view')
local disk = require('deja-view.disk')
local memory = require('deja-view.memory')

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
    deja_view.setup({
      driver = function()
        return memory
      end,
    })
    memory.clear()
    vim.cmd.enew()
  end)

  after_each(function()
    config.set_config(nil)
    vim.cmd('%bwipeout!')
  end)

  it('saves and restores views across buffer loads', function()
    deja_view.setup({
      save_dir = vim.fn.tempname(),
      driver = function()
        return disk
      end,
    })

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
  end)

  it('ignores views that are out of bounds', function()
    local path = create_file(5)
    vim.cmd.edit(path)
    memory.write(path, { lnum = 50, col = 0, topline = 40 })

    deja_view.restore()

    assert.are.equal(1, vim.fn.winsaveview().lnum)
    vim.fn.delete(path)
  end)

  it('does nothing for unnamed buffers', function()
    deja_view.save()
    deja_view.restore()

    assert.is_nil(memory.read(''))
  end)

  describe('autocommands', function()
    before_each(function()
      vim.cmd.runtime({ 'plugin/deja-view.lua', bang = true })
    end)

    after_each(function()
      vim.api.nvim_del_augroup_by_name('deja-view')
    end)

    it(
      'keeps the cursor in place when reloading a buffer with :edit',
      function()
        local path = create_file(100)
        vim.cmd.edit(path)
        vim.fn.winrestview({ lnum = 50, col = 3, topline = 40 })

        -- Leaving the buffer saves the view at line 50.
        vim.cmd.enew()
        vim.cmd.edit(path)

        -- Move somewhere else, then reload the file in place.
        vim.fn.winrestview({ lnum = 80, col = 0, topline = 70 })
        vim.cmd.edit()

        assert.are.equal(80, vim.fn.winsaveview().lnum)
        vim.fn.delete(path)
      end
    )

    it('keeps the cursor in place when autoread reloads a buffer', function()
      local path = create_file(100)
      vim.cmd.edit(path)
      vim.fn.winrestview({ lnum = 50, col = 3, topline = 40 })

      -- Leaving the buffer saves the view at line 50.
      vim.cmd.enew()
      vim.cmd.edit(path)
      vim.fn.winrestview({ lnum = 80, col = 0, topline = 70 })

      -- Change the file behind nvim's back and let autoread reload it.
      local contents = {}
      for index = 1, 100 do
        table.insert(contents, 'changed line ' .. index)
      end
      vim.fn.writefile(contents, path)

      vim.o.autoread = true
      vim.cmd.checktime()

      assert.are.equal(80, vim.fn.winsaveview().lnum)
      vim.fn.delete(path)
    end)

    it('captures the view when the current buffer unloads', function()
      local path = create_file(100)
      vim.cmd.edit(path)
      vim.fn.winrestview({ lnum = 50, col = 3, topline = 40 })

      -- No BufLeave happens here; only the unload can save the view.
      vim.cmd.bwipeout()
      vim.cmd.edit(path)

      assert.are.equal(50, vim.fn.winsaveview().lnum)
      assert.are.equal(40, vim.fn.winsaveview().topline)
      vim.fn.delete(path)
    end)

    it('restores the view when reading a buffer fresh', function()
      local path = create_file(100)
      vim.cmd.edit(path)
      vim.fn.winrestview({ lnum = 50, col = 3, topline = 40 })

      vim.cmd.enew()
      vim.cmd('bwipeout! ' .. vim.fn.bufnr(path))
      vim.cmd.edit(path)

      assert.are.equal(50, vim.fn.winsaveview().lnum)
      assert.are.equal(40, vim.fn.winsaveview().topline)
      vim.fn.delete(path)
    end)

    it('restores the view when reloading an unloaded buffer', function()
      local path = create_file(100)
      vim.cmd.edit(path)
      vim.fn.winrestview({ lnum = 50, col = 3, topline = 40 })

      -- Unloading drops nvim's own memory of the window; only the saved
      -- view can bring the position back.
      vim.cmd.enew()
      vim.cmd('bunload! ' .. vim.fn.bufnr(path))
      vim.cmd.edit(path)

      assert.are.equal(50, vim.fn.winsaveview().lnum)
      assert.are.equal(40, vim.fn.winsaveview().topline)
      vim.fn.delete(path)
    end)
  end)
end)
