local driver = require('deja-view._.driver')
local memory = require('deja-view._.memory')

describe('driver', function()
  before_each(function()
    vim.g.deja_view_mode = nil
    vim.b.deja_view_mode = nil
    memory.clear()
  end)

  it('defaults to the disk driver', function()
    assert.are.equal(require('deja-view._.disk'), driver.load())
  end)

  it('respects the global save mode', function()
    vim.g.deja_view_mode = 'memory'

    assert.are.equal(memory, driver.load())
  end)

  it('prioritizes buffer settings over global settings', function()
    vim.g.deja_view_mode = 'memory'
    vim.b.deja_view_mode = 'disk'

    assert.are.equal(require('deja-view._.disk'), driver.load())
  end)

  it('never remembers commit messages', function()
    vim.bo.filetype = 'gitcommit'

    local loaded = driver.load()
    loaded.write('/commit', { lnum = 1 })

    assert.is_nil(loaded.read('/commit'))

    vim.bo.filetype = ''
  end)

  it('never remembers terminal buffers', function()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_term(bufnr, {})

    local loaded = driver.load(bufnr)
    loaded.write('/terminal', { lnum = 1 })

    assert.is_nil(loaded.read('/terminal'))

    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)

  it('survives unknown save modes by using the memory driver', function()
    vim.g.deja_view_mode = 'ipfs'

    assert.are.equal(memory, driver.load())
  end)
end)
