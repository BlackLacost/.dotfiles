vim.cmd("filetype plugin indent on")
-- vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.hidden = true -- default on
vim.o.whichwrap = "b,s" -- vim.o.whichwrap = 'b,s,<,>,[,],h,l'
vim.o.pumheight = 10
vim.o.fileencoding = "utf-8"
vim.o.cmdheight = 1
vim.o.splitbelow = true -- При горизонтальном сплите, окно сплита появится внизу
vim.o.splitright = true
vim.opt.termguicolors = true
vim.o.conceallevel = 0
vim.o.showtabline = 1
vim.o.showmode = false -- Проказывать в каком моде мы находимся INSERT, VISUAL, REPLACE
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.o.timeoutlen = 100
vim.o.hlsearch = true
vim.o.ignorecase = true -- Игнорировать регистр букв при поиске
vim.o.scrolloff = 3
vim.o.sidescrolloff = 5
vim.o.mouse = "a" -- Включение мыши
vim.wo.wrap = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.cursorline = true
vim.wo.signcolumn = "yes" -- Всегда отображать вертикальную колонку для символов диагностики
vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.expandtab = true
vim.bo.expandtab = true

if vim.fn.has "wsl" == 1 then
  vim.o.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enable = 0,
  }

  vim.g.im_select_command = "im-select.exe"
  vim.g.im_select_default = "1033"
end

-- Disable automatic commenting on newline
vim.cmd([[autocmd FileType * setlocal formatoptions-=cro]])

vim.cmd([[autocmd BufNewFile,BufRead {apps,tsconfig*}.json setlocal filetype=jsonc]])

vim.cmd([[
augroup AllFileType
  autocmd!
  autocmd FileType * set nowrap
augroup END
]])

vim.cmd([[
augroup Markdown
  autocmd!
  autocmd FileType markdown set wrap
augroup END
]])

-- if vim.fn.has "win32" == 1 then
--   vim.o.shell = "pwsh"
-- end
