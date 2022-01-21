vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	virtual_text = {
		spacing = 5,
		severity_limit = "Warning",
	},
	update_in_insert = true,
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "html", "javascript", "lua", "typescript", "json", "jsonc", "graphql", "prisma" },
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	highlight = {
		enable = true, -- false will disable the whole extension
		additional_vim_regex_highlighting = false,
	},
	autotag = {
		enable = true,
	},
	rainbow = {
		enable = true,
		-- Подсвечивает html теги полностью, а не только скобки
		extended_mode = true,
		-- Do not enable for files with more than n lines, int
		max_file_lines = nil,
	},
	context_commentstring = {
		enable = true,
	},
	autopairs = {
		enable = true,
	},

	tree_docs = {
		enable = true,
		keymaps = {
			doc_node_at_cursor = "<leader>rj",
			doc_all_in_range = "<leader>rj",
		},
	},
})
