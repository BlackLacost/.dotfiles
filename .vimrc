" Plugins{{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $HOME/.vimrc
endif
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'

call plug#end()
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
set tabstop=4
set shiftwidth=4
set softtabstop=4
"}}}
" Leader & LocalLeader{{{
let mapleader = ","
noremap M <nop>
let maplocalleader = "M"
" }}}
" Edit & Save vimrc{{{
" Редактирование и сохранение vimrc
" TODO use vimrc_file = $HOME/_vimrc
if has('win32')
    nnoremap <Leader>ev :vsplit $HOME/_vimrc<cr>
    nnoremap <Leader>sv :source $HOME/_vimrc<cr>
else
    nnoremap <Leader>ev :vsplit $HOME/.vimrc<cr>
    nnoremap <Leader>sv :source $HOME/.vimrc<cr>
endif
" }}}
" UI Layout{{{
set number relativenumber
set nocursorline
set nowrap
set textwidth=0
set colorcolumn=0
"}}}
" Searching{{{
set incsearch              " Search as characters are entered
" }}}
" Folding{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker foldlevel=0
augroup END
" }}}
" Abbreviations{{{
iabbrev bg@ blacklacost@gmail.com
iabbrev ilbg -- <cr>Ilya Lisin<cr>blacklacost@gmail.com
"}}}
" Mappings{{{
set pastetoggle=<F2>

" Более удобное передвижение блоков
vnoremap > >gv
vnoremap < <gv

" Switching between buffers
" Set commands to switching between buffers
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprevious!<CR>
nnoremap <C-X> :bprevious<bar>split<bar>bnext<bar>bdelete<CR>

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
" Plugins options {{{1
" 'morhetz/gruvbox'{{{2
" let g:gruvbox_italic=1
" set termguicolors
" colorscheme gruvbox
" }}}
" 'scrooloose/nerdtree'{{{2
nmap <C-n> :NERDTreeToggle<CR>
" }}}
" neoclide/coc.nvim{{{2
let g:coc_global_extensions = [
    \ 'coc-highlight',
    \ ]
"}}}
"}}}
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle
