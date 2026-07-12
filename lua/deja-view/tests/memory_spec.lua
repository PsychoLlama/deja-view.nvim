local memory = require('deja-view.memory')

describe('memory', function()
  before_each(function()
    memory.clear()
  end)

  it('round-trips a view', function()
    local view = { lnum = 10, col = 2, topline = 5 }
    memory.write('/path/to/file.txt', view)

    assert.are.same(view, memory.read('/path/to/file.txt'))
  end)

  it('returns nil for unknown files', function()
    assert.is_nil(memory.read('/never/saved.txt'))
  end)

  it('forgets everything when cleared', function()
    memory.write('/path/to/file.txt', { lnum = 1 })
    memory.clear()

    assert.is_nil(memory.read('/path/to/file.txt'))
  end)
end)
