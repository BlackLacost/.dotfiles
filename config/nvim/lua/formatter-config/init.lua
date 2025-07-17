local function prettier()
	return {
		exe = "prettier",
		args = {
			-- Определяет приоритет использования настроек
			"--config-precedence",
			-- Если конфиг файл, например, .prettierrc существует, то он имеет приоритет.
			"prefer-file",
			"--stdin-filepath",
			vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
			"--single-quote",
			"--no-semi",
			"--arrow-parens",
			"always",
			"--print-width",
			"100",
			"--trailing-comma",
			"all",
		},
		stdin = true,
	}
end

require("formatter").setup({
	logging = false,
	filetype = {
		javascript = { prettier },
		javascriptreact = { prettier },
		typescript = { prettier },
		typescriptreact = { prettier },
		yaml = { prettier },
		prisma = { prettier },
		json = { prettier },
		jsonc = { prettier },
		lua = {
			function()
				return {
					exe = "stylua",
					args = { "--stdin-filepath", vim.fn.expand("%:t"), "-" },
					stdin = true,
				}
			end,
		},
		css = { prettier },
		scss = { prettier },
		graphql = { prettier },
		markdown = { prettier },
		telekasten = { prettier },
	},
})

require("formatter.util").print = function() end

vim.api.nvim_set_keymap("n", "<leader>rp", "<cmd>MyFormat<CR>", { noremap = true, silent = true })

-- 2000 timeout on formatting_seq_sync because eslint lsp is slow
vim.cmd([[ command! MyFormat :lua vim.lsp.buf.formatting_seq_sync({}, 2000); vim.cmd "Format" <CR> ]])

vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.tsx,*.jsx,*.yml,*.yaml,*.json,*.css,*.scss,*.md,*.lua,*.prisma,*.graphql FormatWrite
augroup END
]],
	true
)
