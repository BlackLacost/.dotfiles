" VimPlug: =====================================================================
" Autoload vim-plug: {{{

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $HOME/.config/nvim/init.vim
endif

"}}}
call plug#begin('~/.config/nvim/plugged')
" General plugins: {{{

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lyokha/vim-xkbswitch'
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'jmcantrell/vim-virtualenv'
Plug 'PieterjanMontens/vim-pipenv'
Plug 'airblade/vim-rooter'
Plug 'blacklacost/potion'

" }}}
" Navigation: {{{

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsusmi/tagbar'
Plug 'vifm/vifm.vim'
Plug 'easymotion/vim-easymotion'

"}}}
" Git: {{{

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'

"}}}
" Syntax: {{{

Plug 'PotatoesMaster/i3-vim-syntax'
"Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
"Plug 'gu-fan/riv.vim'
"Plug 'Rykka/InstantRst'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'blacklacost/xi.vim'

"}}}
" Themes: {{{

Plug 'morhetz/gruvbox'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'blacklacost/memory-color-theme.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

"}}}
call plug#end()

" Settigns: ====================================================================
" Basic: {{{

set mouse=a
filetype plugin on      " need for vimwiki

set pyxversion=3

" Clipboard
" yank, delete, put используют помимо unnamed регистра (""), еще и "+.
set clipboard=unnamedplus

" Spaces & Tabs
" Позволяет при табуляции вставлять пробелы.
" Чтобы вставить Tab когда опция включена нажми CTRL+v Tab
set expandtab
set smarttab
set smartindent
set tabstop=4
set shiftwidth=4

" UI Layout
set nonumber norelativenumber
set cursorline
set nowrap
set textwidth=80
set colorcolumn=81

" Disable automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Automatically deletes all trailing whitespace
autocmd BufWritePre * %s/\s\+$//e
" and newlines at end of file on save
autocmd BufWritePre * %s/\n\+\%$//e

"}}}
" Cursor: {{{

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
" Folding: {{{

set foldcolumn=0

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
" Functions: {{{

" Show highlighting groups for current word
function! g:SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" }}}
" Colors: {{{

syntax on
set t_Co=256                " t_** is terminal_options
set background=dark

if has("termguicolors")
    set termguicolors
endif
" Fonts and Encoding
set encoding=UTF-8

"}}}
" Themes: {{{

" Gruvbox:
let g:gruvbox_italic=1
set termguicolors
"colorscheme gruvbox

" Challenger_deep:
"colorscheme challenger_deep

" Memory Color Theme:
colorscheme memorycolor

" Trancparency
"hi! Normal ctermbg=NONE guibg=NONE

"}}}

" Plugin Configuration: ========================================================
" Airline: {{{

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

" theme
let g:airline_theme = 'deus'

"}}}
" Coc: {{{

let g:coc_global_extensions = [
    \ 'coc-highlight',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-json',
    \ 'coc-python',
    \ 'coc-pyright',
    \ ]
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"}}}
" Fzf: {{{

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
map <C-f>c :Files<CR>
map <C-f>r :Files /<CR>
map <C-f>d :Files ~/.dotfiles<CR>
map <C-f>h :Files ~<CR>
map <C-b> :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>


let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!{.git,node_modules}"'


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
" Markdown: {{{

let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let vim_markdown_preview_pandoc=1

"}}}
" NERDTree: {{{

let NERDTreeShowHidden=1

"}}}
" Potion: {{{

" Путь до potion, если не добавлен в PATH
let g:potion_command = "~/potion/bin/potion"

"}}}
" Tagbar: {{{

" Add support for reStructuredText files in tagbar.
let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : 'rst2ctags',
    \ 'ctagsargs' : '-f - --sort=yes --sro=»',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '»',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

"}}}
" Xkbswitch: {{{

let g:XkbSwitchEnabled = 1

"}}}
" Vimwiki: {{{

let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_list = [{'path': '~/.knowledge', 'syntax': 'markdown', 'ext': '.md'}]

"}}}
" Rooter: {{{

let g:rooter_cd_cmd = 'lcd'

"}}}

" Mappings: ====================================================================
" General: {{{
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

nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

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

" Show highlighting groups for current word
nmap <localleader>g :call g:SynStack()<CR>

nmap <localleader>cc :set cursorcolumn!<CR>
nmap <localleader>cl :set cursorline!<CR>

nnoremap gt :tabnext<CR>
nnoremap gT :tabprevious<CR>

"}}}
" Coc: {{{

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
  "nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  "inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  "inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  "vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"}}}
" Goyo: {{{

map <leader>f :Goyo \| set bg=light \| set linebreak<CR>

"}}}
" Markdown {{{

"nmap <leader>m <Plug>MarkdownPreview
nmap <leader>m <Plug>MarkdownPreviewToggle

"}}}
" NERDComment: {{{

vmap <C-c> <plug>NERDCommenterToggle
nmap <C-c> <plug>NERDCommenterToggle

"}}}
" NERDTree: {{{

nmap <C-n> :NERDTreeToggle<CR>

"}}}
" Tagbar: {{{

nnoremap <F8> :TagbarToggle<CR>

"}}}
