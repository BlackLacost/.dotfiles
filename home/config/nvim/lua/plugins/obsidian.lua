return {
  -- https://github.com/epwalsh/obsidian.nvim
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- see below for full list of optional dependencies 👇
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    completion = {
      blink = true,
      nvim_cmp = false,
    },
    workspaces = {
      {
        name = 'personal',
        path = '~/pkm',
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },

      {
        name = 'no-vault',
        path = function()
          -- alternatively use the CWD:
          -- return assert(vim.fn.getcwd())
          return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
        overrides = {
          notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
          new_notes_location = 'current_dir',
          templates = {
            folder = vim.NIL,
          },
          disable_frontmatter = true,
        },
      },
    },

    legacy_commands = false,
    disable_frontmatter = true,
    new_notes_location = 'notes_subdir',
    note_id_func = function(title)
      local prefix = tostring(os.date('%Y-%m-%d', os.time()))
      if title ~= nil then
        -- TODO: поддержка русского языка или перевод в slug
        title = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- TODO: время не генерится
        title = os.time()
      end
      return prefix .. '-' .. title
    end,
    daily_notes = {
      folder = 'diary',
      date_format = '%Y-%m-%d',
      template = 'daily',
    },
    ui = {
      enable = false,
    },
    templates = {
      folder = 'meta/templates',
    },
    picker = {
      name = 'telescope.nvim',
    },

    vim.keymap.set('n', '<leader>of', '<cmd>Obsidian follow_link<cr>', { desc = '[O]bsidian [F]ollow Link' }),
    vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<cr>'),
    vim.keymap.set('n', '<leader>oo', '<cmd>Obsidian open<cr>'),
    vim.keymap.set('n', '<leader>od', '<cmd>Obsidian dailies<cr>'),
    vim.keymap.set('n', '<leader>or', '<cmd>Obsidian rename<cr>'),
    vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian template<cr>'),
    vim.keymap.set('n', '<leader>ow', '<cmd>Obsidian workspace<cr>', { desc = '[O]bsidian [W]orkspace' }),
    vim.keymap.set('n', '<leader>so', '<cmd>Obsidian quick_switch<cr>', { desc = '[S]earch [O]bsidian Quick Switch' }),
    vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<cr>'),
    vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<cr>'),
  },
}
