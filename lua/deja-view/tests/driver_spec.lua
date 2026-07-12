local config = require('deja-view.config')
local disk = require('deja-view.disk')
local driver = require('deja-view.driver')
local memory = require('deja-view.memory')

describe('driver', function()
  before_each(function()
    config.set_config(nil)
    memory.clear()
  end)

  after_each(function()
    config.set_config(nil)
  end)

  describe('default selector', function()
    it('remembers ordinary buffers on disk', function()
      assert.are.equal(disk, driver.default(0))
    end)

    it('never remembers commit messages', function()
      vim.bo.filetype = 'gitcommit'

      assert.is_nil(driver.default(0))

      vim.bo.filetype = ''
    end)

    it('never remembers terminal buffers', function()
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_term(bufnr, {})

      assert.is_nil(driver.default(bufnr))

      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)
  end)

  describe('load', function()
    it('defaults to the disk driver', function()
      assert.are.equal(disk, driver.load())
    end)

    it('uses the configured driver selector', function()
      config.set_config({
        driver = function()
          return memory
        end,
      })

      assert.are.equal(memory, driver.load())
    end)

    it('passes the buffer number to the selector', function()
      local seen
      config.set_config({
        driver = function(bufnr)
          seen = bufnr
          return memory
        end,
      })

      driver.load(42)

      assert.are.equal(42, seen)
    end)

    it('discards writes when the selector returns nil', function()
      config.set_config({
        driver = function()
          return nil
        end,
      })

      local loaded = driver.load()
      loaded.write('/whatever', { lnum = 1 })

      assert.is_nil(loaded.read('/whatever'))
    end)
  end)
end)
