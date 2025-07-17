vim.g.mapleader = " "

local map = vim.api.nvim_set_keymap

map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- gv вернуться к последнему визуальному выделению
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

-- gv вернуться к последнему визуальному выделению
map("n", "j", "gj", { noremap = true, silent = true })
map("n", "k", "gk", { noremap = true, silent = true })
map("n", "gj", "j", { noremap = true, silent = true })
map("n", "gk", "k", { noremap = true, silent = true })

-- Terminal
map("t", "<C-y>", [[<C-\><C-n>]], { noremap = false, silent = true })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
