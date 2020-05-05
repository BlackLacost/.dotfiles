" Plugins{{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $HOME/.vimrc
endif
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'vimwiki/vimwiki'

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
set smartindent
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
" Disable automatic commenting on newline:{{{
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" }}}
" Automatically deletes all trailing whitespace and newlines at end of file on save{{{
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
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
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0
nmap <leader>m <Plug>MarkdownPreview
nmap <leader>mt <Plug>MarkdownPreviewToggle
"}}}
" 'vimwiki/vimwiki'{{{2
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
"}}}
" 'junegunn/goyo.vim'{{{2
map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" }}}
"}}}
