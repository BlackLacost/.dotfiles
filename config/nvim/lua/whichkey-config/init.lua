local wk = require("which-key")

local mappings = {
  q = { ':q<cr>', 'Quit' },
  Q = { ':wq<cr>', 'Quit & Save' },
  w = { ':w<cr>', 'Save' },
  x = { ':bdelete<cr>', 'Close' },
  E = { ':e ~/.config/nvim/init.lua<cr>', 'Edit config' },
}

local opts = { prefix = '<leader>' }

wk.register(mappings, opts)

