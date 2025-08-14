local client = vim.lsp.start {
  name = 'learnlsp',
  cmd = {
    '/home/ilya/code/learnlsp/main',
  },
}

if not client then
  vim.notify 'hey, you didnt do the client thing good'
  return
else
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      vim.lsp.buf_attach_client(0, client)
    end,
  })
end
