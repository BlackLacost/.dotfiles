set mouse=a
filetype plugin on      " need for vimwiki

" Cursor
"Cursor settings:
"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
" Из-за смены курсоров в vi mode bash курсор нужно
" автоматически сбрасывать при входе в vim
autocmd VimEnter * silent execute '!echo -ne "\e[2 q"' | redraw!
let &t_SI.="\e[6 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)

" Clipboard
" yank, delete, put используют помимо unnamed регистра (""), еще и "+.
set clipboard=unnamedplus

" Colors
syntax on
set t_Co=256                " t_** is terminal_options
set background=dark

if has("termguicolors")
    set termguicolors
endif

" Fonts and Encoding
set encoding=UTF-8

" Spaces & Tabs
" Позволяет при табуляции вставлять пробелы.
" Чтобы вставить Tab когда опция включена нажми CTRL+v Tab
set expandtab
set smarttab
set smartindent
set tabstop=4
set shiftwidth=4

" Leader & LocalLeader
" Пробовал leader на пробел, но тогда если используешь leader в insert mode,
" то получаешь лаг каждый раз когда жмешь пробел.
let mapleader = ","
noremap M <nop>
let maplocalleader = "M"

" UI Layout
set number relativenumber
set nocursorline
set nowrap
set textwidth=80
set colorcolumn=81

" Disable automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Automatically deletes all trailing whitespace and newlines at end of file on save{{{
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
"}}}
" Searching{{{
set incsearch              " Search as characters are entered

" Включение подсветки всех совпадений для удобства
nnoremap / :set hlsearch<cr>/

" Когда начинаешь уже редактировать, то дополнительные подсветки будут раздрожать
augroup SearchHighlightOff
    autocmd!
    autocmd InsertEnter * set nohlsearch
augroup END
" }}}
" Folding{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker foldlevel=0
augroup END
" }}}
" Compiling{{{
" ~~~~~ Compile document
map <leader>c :w! \| !compiler <c-r>%<CR>
" ~~~~~ Turn on Autocompiler mode
"map <leader>a :!setsid autocomp % &<CR>
" ~~~~~ Open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>
"}}}
" Abbreviations{{{
iabbrev bg@ blacklacost@gmail.com
iabbrev ilbg -- <cr>Ilya Lisin<cr>blacklacost@gmail.com
"}}}
" FileType{{{
augroup filetype_python
    autocmd!
    autocmd FileType python :iabbrev <buffer> iff if:<left>
augroup END

augroup filetype_rst
    autocmd!
    autocmd FileType rst setlocal tabstop=3 shiftwidth=3
    autocmd FileType rst setlocal nowrap textwidth=80 colorcolumn=81
augroup END
"}}}
