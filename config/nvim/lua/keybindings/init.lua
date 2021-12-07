vim.g.mapleader = ' '

local map = vim.api.nvim_set_keymap

map('n', '<C-h>', '<C-w>h', { noremap = true, silent = false })
map('n', '<C-j>', '<C-w>j', { noremap = true, silent = false })
map('n', '<C-k>', '<C-w>k', { noremap = true, silent = false })
map('n', '<C-l>', '<C-w>l', { noremap = true, silent = false })

-- gv вернуться к последнему визуальному выделению
map('v', '<', '<gv', { noremap = true, silent = false })
map('v', '>', '>gv', { noremap = true, silent = false })

-- nvim-tree
map('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Terminal
map('t', '<C-h>', '<C-\\><C-n><C-h>', { noremap = true, silent = false })
map('t', '<C-j>', '<C-\\><C-n><C-j>', { noremap = true, silent = false })
map('t', '<C-k>', '<C-\\><C-n><C-k>', { noremap = true, silent = false })
map('t', '<C-l>', '<C-\\><C-n><C-l>', { noremap = true, silent = false })

map('n', '<C-w>tv', ':execute "vsplit" | :execute "terminal" | :execute "vertical resize 70"<cr>', { noremap = true, silent = false })
map('n', '<C-w>ts', ':execute "split" | :execute "terminal" | :execute "resize 12"<cr>', { noremap = true, silent = false })

