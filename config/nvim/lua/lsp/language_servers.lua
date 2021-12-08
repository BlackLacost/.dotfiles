-- Setup lspconfig.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local flags = {
	debounce_text_changes = 150,
}

local lspconfig = require("lspconfig")

lspconfig.html.setup({
	capabilities = capabilities,
	flags = flags,
})

lspconfig.cssls.setup({
	capabilities = capabilities,
	flags = flags,
})

lspconfig.tsserver.setup({
	capabilities = capabilities,
	flags = flags,
})

lspconfig.pylsp.setup({
	capabilities = capabilities,
	flags = flags,
})

local configs = require("lspconfig/configs")
capabilities.textDocument.completion.completionItem.snippetSupport = true

configs.emmet_ls = {
	default_config = {
		cmd = { "emmet-ls", "--stdio" },
		filetypes = { "html", "css", "blade" },
		root_dir = function(fname)
			return vim.loop.cwd()
		end,
		settings = {},
	},
}

lspconfig.emmet_ls.setup({
	capabilities = capabilities,
	flags = flags,
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
