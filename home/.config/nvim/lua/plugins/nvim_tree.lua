local g = vim.g
local api = vim.api

g.nvim_tree_quit_on_open = 1
g.nvim_tree_gitignore = 1
g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1
}
g.nvim_tree_group_empty = 1
g.nvim_tree_window_picker_exclude = {
  filetype = {
    "packer",
    "qf",
    "Trouble"
  }
}
g.nvim_tree_icons = {
     default= '',
     symlink= '',
     git= {
       unstaged = "✗",
       staged = "✓",
       unmerged = "",
       renamed = "➜",
       untracked = "★",
       deleted = "",
       ignored = "◌"
       },
     folder = {
       arrow_open = "",
       arrow_closed = "",
       default = "",
       open = "",
       empty = "",
       empty_open = "",
       symlink = "",
       symlink_open = "",
       },
       lsp= {
         hint = "",
         info = "",
         warning = "",
         error = "",
       }
     }
api.nvim_set_keymap('n', '-', ':NvimTreeFindFile<CR>', {noremap = true, silent = true})
api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
api.nvim_set_keymap('n', '<leader>r', ':NvimTreeRefresh<CR>', {noremap = true, silent = true})

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  lsp_diagnostics     = false,
  auto_close          = false,
  hijack_cursor       = true,
  update_cwd          = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = { 'fzf' }
  },
  ignore_ft_on_setup = {'.git', 'node_modules', 'dist'},
  system_open = {
    cmd  = nil,
    args = {}
  },
}
