" Plugins{{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $HOME/.vimrc
endif
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'morhetz/gruvbox'
Plug 'lyokha/vim-xkbswitch'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
"Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'gu-fan/riv.vim'

call plug#end()
"}}}
" Some Basics{{{
set mouse=a
filetype plugin on      " need for vimwiki
"}}}
" Cursor{{{
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
"}}}
" Clipbard{{{
" yank, delete, put используют помимо unnamed регистра (""), еще и "+.
set clipboard=unnamedplus
"}}}
" Colors{{{
syntax on
set t_Co=256                " t_** is terminal_options
set background=light
"}}}
" Fonts and Encoding{{{
set encoding=UTF-8
" }}}
" Spaces & Tabs{{{
set expandtab
set smarttab
set smartindent
set tabstop=4
set shiftwidth=4
"}}}
" Leader & LocalLeader{{{
let mapleader = "\<Space>"
"noremap M <nop>
let maplocalleader = ","
" }}}
" Edit & Save vimrc{{{
" Редактирование и сохранение vimrc
" TODO use vimrc_file = $HOME/_vimrc
if has('win32')
    nnoremap <Leader>ev :vsplit $HOME/_vimrc<cr>
    nnoremap <Leader>sv :source $HOME/_vimrc<cr>
else
    nnoremap <Leader>ev :split $HOME/.vimrc<cr>
    nnoremap <Leader>sv :source $HOME/.vimrc<cr>
endif
" }}}
" UI Layout{{{
set number relativenumber
set nocursorline
set nowrap
set textwidth=80
set colorcolumn=81
"}}}
" Disable automatic commenting on newline:{{{
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" }}}
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
" Mappings{{{
set pastetoggle=<F2>

" Для удобной работы в PRIMARY buffer
noremap <Leader>y "*y
noremap <Leader>p "*p

" Более удобное передвижение блоков
vnoremap > >gv
vnoremap < <gv

" Чтобы удобней работать, когда включен wrap
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" Позволяет не пользоваться capslock
inoremap <leader><C-u> <Esc>gUiwea
inoremap <leader><C-d> <Esc>guiwea
inoremap <leader><C-t> <Esc>g~iwea

" Switching between buffers
" Set commands to switching between buffers
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprevious!<CR>
nnoremap <C-X> :bprevious<bar>split<bar>bnext<bar>bdelete<CR>

nnoremap H ^
nnoremap L $
nnoremap $ <nop>
nnoremap ^ <nop>

" Сделать двойны кавычки для выделенного блока
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>`>ll

" Навигация и ресайзинг окнон{{{2
map <silent> <C-h> :call WinMove('h')<CR>
map <silent> <C-j> :call WinMove('j')<CR>
map <silent> <C-k> :call WinMove('k')<CR>
map <silent> <C-l> :call WinMove('l')<CR>

function! WinMove(key)
	let t:curwin = winnr()
	execute "wincmd ".a:key

	if (t:curwin == winnr())
		if (match(a:key,'[jk]'))
			wincmd v
		else
			wincmd s
		endif

        execute "wincmd ".a:key
    endif
endfunction

nmap <silent> <Leader>+ :exe "resize " . (winheight(0) + 10)<CR>
nmap <silent> <Leader>- :exe "resize " . (winheight(0) - 10)<CR>
nmap <silent> <Leader>> :exe "vertical resize " . (winwidth(0) + 10)<CR>
nmap <silent> <Leader>< :exe "vertical resize " . (winwidth(0) - 10)<CR>
"}}}
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
" Plugins options {{{1
" 'lyokha/vim-xkbswitch'{{{2
let g:XkbSwitchEnabled = 1
"}}}
" 'junegunn/fzf'{{{2
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

map <C-f> :Files<CR>
map <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>


let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden"


" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)


" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
"}}}
" 'morhetz/gruvbox'{{{2
" let g:gruvbox_italic=1
" set termguicolors
" colorscheme gruvbox
" }}}
" 'scrooloose/nerdtree'{{{2
nmap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
" }}}
" neoclide/coc.nvim{{{2
let g:coc_global_extensions = [
    \ 'coc-highlight',
    \ ]
"}}}
" TODO: remap to <C-/> 'scrooloose/nerdcommenter'{{{2
vmap <C-c> <plug>NERDCommenterToggle
nmap <C-c> <plug>NERDCommenterToggle
"}}}
" 'iamcco/markdown-preview.nvim'{{{2
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let vim_markdown_preview_pandoc=1
"nmap <leader>m <Plug>MarkdownPreview
nmap <leader>m <Plug>MarkdownPreviewToggle
"}}}
" 'vimwiki/vimwiki'{{{2
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_list = [{'path': '~/.knowledge', 'syntax': 'markdown', 'ext': '.md'}]
"}}}
" 'junegunn/goyo.vim'{{{2
map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" }}}
"}}}
