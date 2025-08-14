-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--  See `:help vim.keymap.set()`

vim.keymap.set('n', '<leader>xf', '<cmd>source %<CR>', { desc = 'E[x]ecute Current [F]ile' })
vim.keymap.set('n', '<leader>xl', ':.lua<CR>', { desc = 'E[x]ecute Current [L]ine' })
vim.keymap.set('v', '<leader>xl', ':lua<CR>', { desc = 'E[x]ecute Selected [L]ines' })

--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Remove search highlights' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set('n', '<leader>wv', ':vsplit<CR>', { desc = '[W]indow Split [V]ertical' })
vim.keymap.set('n', '<leader>wh', ':split<CR>', { desc = '[W]indow Split [H]orizontal' })

vim.keymap.set('v', '<', '<gv', { desc = 'Indent left in visual mode' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right in visual mode' })

vim.keymap.set('n', 'zh', '<cmd>set foldlevel=0<CR>')
vim.keymap.set('n', 'zj', '<cmd>set foldlevel=1<CR>')
vim.keymap.set('n', 'zk', '<cmd>set foldlevel=2<CR>')
vim.keymap.set('n', 'zl', '<cmd>set foldlevel=3<CR>')
vim.keymap.set('n', 'z;', '<cmd>set foldlevel=4<CR>')

vim.o.langmap =
  'йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,ж\\;,э\',ё`,яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ъ},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж:,Э",ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>,Ё~'

vim.keymap.set('i', '<C-ц>', '<C-w>', { noremap = true })
vim.keymap.set('i', '<C-х>', '<Esc>', { noremap = true })
vim.keymap.set('i', '<C-щ>', '<C-o>', { noremap = true })

-- These mappings control the size of splits (height/width)
vim.keymap.set('n', '<M-,>', '<c-w>5<')
vim.keymap.set('n', '<M-.>', '<c-w>5>')
vim.keymap.set('n', '<M->>', '<C-W>+')
vim.keymap.set('n', '<M-<>', '<C-W>-')
