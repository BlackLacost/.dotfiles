-- https://github.com/folke/lazydev.nvim
-- Позволяет получить типы в runtime
-- Также решает проблему глобального переменной vim
-- https://www.youtube.com/watch?v=bTWWFQZqzyI LSP in Neovim (with like 3 lines of code)

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
