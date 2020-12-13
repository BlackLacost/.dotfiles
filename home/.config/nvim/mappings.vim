" Leader & LocalLeader
" Пробовал leader на пробел, но тогда если используешь leader в insert mode,
" то получаешь лаг каждый раз когда жмешь пробел.
let mapleader = ","
noremap M <nop>
let maplocalleader = "M"

" Редактирование и source init.vim
nnoremap <Leader>evi :split $HOME/.config/nvim/init.vim<cr>
nnoremap <Leader>evm :split $HOME/.config/nvim/mappings.vim<cr>
nnoremap <Leader>evp :split $HOME/.config/nvim/vim-plug.vim<cr>
nnoremap <Leader>evs :split $HOME/.config/nvim/basic-settings.vim<cr>
nnoremap <Leader>sv :source $HOME/.config/nvim/init.vim<cr>

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
