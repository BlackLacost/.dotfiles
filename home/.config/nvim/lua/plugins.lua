return require('packer').startup(function()

    -- General plugins:
    use {'neoclide/coc.nvim', branch = 'release'}
    use 'lyokha/vim-xkbswitch'
    use 'junegunn/goyo.vim'
    use 'scrooloose/nerdcommenter'
    use 'jmcantrell/vim-virtualenv'
    use 'PieterjanMontens/vim-pipenv'
    use 'airblade/vim-rooter'
    use 'blacklacost/potion'

    -- Navigation
    use {'junegunn/fzf', rtp = '/user/local/opt/fzf' }
    use 'junegunn/fzf.vim'
    use 'scrooloose/nerdtree'
    -- TODO: Не устанавливается
    --use 'majutsusmi/tagbar'
    use 'vifm/vifm.vim'
    use 'easymotion/vim-easymotion'

    -- Git
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'
    use 'Xuyuanp/nerdtree-git-plugin'

    -- Syntax
    use 'PotatoesMaster/i3-vim-syntax'
    -- Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
    -- Plug 'gu-fan/riv.vim'
    -- Plug 'Rykka/InstantRst'
    -- use 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
    use 'blacklacost/xi.vim'


    -- Themes
    use 'morhetz/gruvbox'
    -- use 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
    use 'blacklacost/memory-color-theme.vim'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
    use 'ryanoasis/vim-devicons'
end)
