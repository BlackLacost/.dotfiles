return require('packer').startup(function()

    -- General plugins:
    use 'neovim/nvim-lspconfig'
    use {
        'kabouzeid/nvim-lspinstall',
        config = function() require'plugins/lsp' end
    }
    -- TODO
    -- use 'lyokha/vim-xkbswitch'

    use 'terrortylor/nvim-comment'
    require('nvim_comment').setup()

    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require'plugins/nvim_tree' end
    }

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/nvim-cmp'

    -- For vsnip user.
--     use 'hrsh7th/cmp-vsnip'
--     use 'hrsh7th/vim-vsnip'
--
    -- For luasnip user.
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- For ultisnips user.
    -- use 'SirVer/ultisnips'
    -- use 'quangnguyen30192/cmp-nvim-ultisnips'

    -- use 'jmcantrell/vim-virtualenv'
    -- use 'PieterjanMontens/vim-pipenv'
    -- use 'airblade/vim-rooter'
    -- use 'blacklacost/potion'

    -- Navigation
    -- use {'junegunn/fzf', rtp = '/user/local/opt/fzf' }
    -- use 'junegunn/fzf.vim'
    -- TODO: Не устанавливается
    --use 'majutsusmi/tagbar'
    -- use 'vifm/vifm.vim'
    -- use 'easymotion/vim-easymotion'

    -- Git
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'
    -- use 'Xuyuanp/nerdtree-git-plugin'

    -- Syntax
    -- use 'PotatoesMaster/i3-vim-syntax'
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
    -- use 'tiagofumo/vim-nerdtree-syntax-highlight'
    -- use 'ryanoasis/vim-devicons'
end)
