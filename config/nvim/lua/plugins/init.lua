return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Nord color schema
  use 'arcticicestudio/nord-vim'

  -- Улучшенная подсветка ключевых слов
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

end)
