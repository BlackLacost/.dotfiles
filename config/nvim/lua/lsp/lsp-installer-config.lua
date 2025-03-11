local lsp_installer = require("nvim-lsp-installer")

local function on_attach(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
end

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	-- Specify the default options which we'll use to setup all servers
	local default_opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	-- Now we'll create a server_opts table where we'll specify our custom LSP server configuration
	local server_opts = {
		-- Provide settings that should only apply to the "eslintls" server
		["sumneko_lua"] = function()
			default_opts.settings = {
				Lua = {
					diagnostics = {
						-- Global mp for mpv scripts
						globals = { "vim", "use", "mp" },
					},
				},
			}
		end,

		["jsonls"] = function()
			default_opts.settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
				},
			}
		end,

		["eslint"] = function()
			default_opts.on_attach = function(client, bufnr)
				-- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
				-- the resolved capabilities of the eslint server ourselves!
				client.resolved_capabilities.document_formatting = true
				on_attach(client, bufnr)
			end
			default_opts.settings = {
				format = { enable = true }, -- this will enable formatting
			}
		end,
	}

	-- Use the server's custom settings, if they exist, otherwise default to the default options
	local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
	server:setup(server_options)
end)
