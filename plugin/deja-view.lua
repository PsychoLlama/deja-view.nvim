local group = vim.api.nvim_create_augroup('deja-view', {})

-- Reloads are the tricky part. Commands like `:edit` or `:checktime` re-read
-- the buffer in place; restoring a saved view there would yank the cursor
-- back in time, fighting nvim's own cursor preservation. Reloads come in two
-- flavors:
--
-- - `:edit` fires BufUnload first, while the old view is still intact. We
--   save there, so the later restore lands where the cursor already was.
-- - `:checktime` (autoread) skips BufUnload entirely. The buffer-local flag
--   below survives the reload and tells us nvim still remembers the view,
--   so there's nothing to restore.
--
-- A genuine fresh read (new session, `:bdelete`, 'nohidden' abandons) always
-- passes through BufUnload, which clears the flag.

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  desc = 'Restore the last known view',
  callback = function(event)
    if not vim.b[event.buf].deja_view_loaded then
      require('deja-view').restore()
    end

    vim.b[event.buf].deja_view_loaded = true
  end,
})

vim.api.nvim_create_autocmd('BufUnload', {
  group = group,
  desc = 'Save the view before a reload or unload',
  callback = function(event)
    -- Hidden buffers unload without a window. The current view describes
    -- some other buffer; BufLeave already captured this one.
    if event.buf == vim.api.nvim_get_current_buf() then
      require('deja-view').save()
    end

    vim.b[event.buf].deja_view_loaded = nil
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'VimLeavePre' }, {
  group = group,
  desc = 'Save the current view',
  callback = function()
    require('deja-view').save()
  end,
})
