local group = vim.api.nvim_create_augroup('deja-view', {})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  desc = 'Restore the last known view',
  callback = function()
    require('deja-view').restore()
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'VimLeavePre' }, {
  group = group,
  desc = 'Save the current view',
  callback = function()
    require('deja-view').save()
  end,
})
