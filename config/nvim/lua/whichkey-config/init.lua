local wk = require("which-key")

local mappings = {
  q = { ':q<cr>', 'Quit' },
  Q = { ':wq<cr>', 'Quit & Save' },
  w = { ':w<cr>', 'Save' },
  x = { ':bdelete<cr>', 'Close' },
  E = { ':e ~/.config/nvim/init.lua<cr>', 'Edit config' },
  f = { ':Telescope find_files<cr>', 'Telescope Find Files' },
  g = { ':Telescope live_grep<cr>', 'Telescope Live Grep' },
  r = { ':Telescope resume<cr>', 'Telescope Resume' },
}

local opts = { prefix = '<leader>' }

wk.register(mappings, opts)

