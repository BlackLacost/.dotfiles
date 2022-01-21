--------------------------------------------------
-- Install packer if not already installed
--------------------------------------------------
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Nord color schema
	use("arcticicestudio/nord-vim")

	-- Улучшенная подсветка ключевых слов
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "nvim-treesitter/nvim-tree-docs" })

	-- status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })

	use({
		"kyazdani42/nvim-tree.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	use({ "windwp/nvim-ts-autotag" })
	-- Разноцветные скобочки
	use({ "p00f/nvim-ts-rainbow" })
	use({ "windwp/nvim-autopairs" })

	use({ "folke/which-key.nvim" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/nvim-lsp-installer" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-cmdline" })
	use({ "hrsh7th/nvim-cmp" })
	use("b0o/schemastore.nvim") -- simple access to json-language-server schemae

	-- For vsnip users.
	use({ "hrsh7th/cmp-vsnip" })
	use({ "hrsh7th/vim-vsnip" })

	-- This tiny plugin adds vscode-like pictograms to neovim built-in lsp
	use({ "onsails/lspkind-nvim" })

	use({ "norcalli/nvim-colorizer.lua" })

	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

	use({ "mhartington/formatter.nvim" })

	use({ "terrortylor/nvim-comment" })

	-- Toggle Terminal
	use({ "akinsho/toggleterm.nvim" })

	-- Telekasten
	use({
		"renerocksai/telekasten.nvim",
		requires = { "renerocksai/calendar-vim" },
	})

	use("tpope/vim-dadbod")
	use("kristijanhusak/vim-dadbod-ui")

	use({ "brglng/vim-im-select" })

	use({
		"iamcco/markdown-preview.nvim", -- preview markdown output in browser
		opt = true,
		ft = { "markdown" },
		config = "vim.cmd[[doautocmd BufEnter]]",
		run = "cd app && yarn install",
		cmd = "MarkdownPreview",
	})
end)
