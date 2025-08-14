-- https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json
-- https://github.com/LuaLS/lua-language-server/wiki
-- https://www.youtube.com/watch?v=bTWWFQZqzyI LSP in Neovim (with like 3 lines of code)
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp

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
  settings = {
    Lua = {
      telemetry = { enable = false },
    },
  },
}
