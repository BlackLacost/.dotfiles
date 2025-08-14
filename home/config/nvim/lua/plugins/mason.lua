return {
  {
    'mason-org/mason.nvim',
    opts = {
      ensure_installed = {
        -- LSP servers (matching your vim.lsp.enable() config)
        'lua-language-server', -- Lua LSP
        'gopls', -- Go LSP
        -- 'typescript-language-server', -- TypeScript LSP
        -- 'tailwindcss-language-server', -- Tailwind CSS LSP
        -- 'html-lsp', -- HTML LSP
        -- 'css-lsp', -- CSS LSP
        -- 'vue-language-server', -- Vue LSP

        -- Formatters (for conform.nvim and general use)
        -- 'stylua',
        -- 'goimports',
        -- Note: gofmt comes with Go installation, not managed by Mason
        -- 'prettier',
        -- 'black',
        -- 'isort',

        -- Linters and diagnostics
        -- 'golangci-lint',
        -- 'eslint_d',
        -- 'luacheck', -- Lua linting

        -- Additional useful tools
        -- 'delve', -- Go debugger
        -- 'shfmt', -- Shell formatter
        -- 'shellcheck', -- Shell linter

        -- Optional but useful additions
        -- "markdownlint", -- Markdown linting
        -- "yamllint",     -- YAML linting
        -- "jsonlint",     -- JSON linting
      },
    },
  },
}
