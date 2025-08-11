-- https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json
-- https://github.com/LuaLS/lua-language-server/wiki

return {
  cmd = {
    'lua-language-server',
  },
  filetypes = {
    'lua',
  },
  root_markers = {
    '.git',
    '.luacheckrc',
    '.luarc.json',
    '.luarc.jsonc',
    '.stylua.toml',
    'selene.toml',
    'selene.yml',
    'stylua.toml',
  },
  -- Важная часть: настройки для работы с типами Neovim
  settings = {
    Lua = {
      workspace = {
        -- Подключаем runtime Neovim.
        -- Без включения типы нормально не работают.
        library = vim.api.nvim_get_runtime_file('', true),
        -- Опционально: игнорируем предупреждения о сторонних библиотеках
        checkThirdParty = false,
      },
      diagnostics = {
        globals = { 'vim' }, -- Разрешаем глобальную переменную `vim`
      },
      telemetry = { enable = false },
    },
  },
  -- settings = {
  --     Lua = {
  --         diagnostics = {
  --             --     disable = { "missing-parameters", "missing-fields" },
  --         },
  --     },
  -- },

  -- single_file_support = true,
  -- log_level = vim.lsp.protocol.MessageType.Warning,
}
