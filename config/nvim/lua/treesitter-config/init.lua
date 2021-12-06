require'nvim-treesitter.configs'.setup {
  ensure_installed = {"html", "javascript", "lua", "typescript"},
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
}

