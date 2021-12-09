local wk = require("which-key")

local Terminal = require("toggleterm.terminal").Terminal

local toggle_float = function()
	local float = Terminal:new({ direction = "float" })
	return float:toggle()
end

local toggle_horizontal = function()
	return Terminal:new({ direction = "horizontal" }):toggle()
end

local toggle_lazygit = function()
	return Terminal:new({ cmd = "lazygit", direction = "float" }):toggle()
end

local toggle_python = function()
	return Terminal:new({ cmd = "python", direction = "float" }):toggle()
end

local mappings = {
	q = { ":q<cr>", "Quit" },
	Q = { ":wq<cr>", "Quit & Save" },
	w = { ":w<cr>", "Save" },
	x = { ":bdelete<cr>", "Close" },
	E = { ":e ~/.config/nvim/init.lua<cr>", "Edit config" },
	f = { ":Telescope find_files<cr>", "Telescope Find Files" },
	g = { ":Telescope live_grep<cr>", "Telescope Live Grep" },
	r = { ":Telescope resume<cr>", "Telescope Resume" },
	b = { ":Telescope buffers<cr>", "Telescope Buffers" },
	l = {
		name = "LSP",
		i = { ":LspInfo<cr>", "Connected Language Servers" },
		w = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List workspace folder" },
		A = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder" },
		R = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder" },
		t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
		gD = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
		gd = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
		h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
		r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
		s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature" },
		l = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
		I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
		a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions" },
		f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Formatting" },
		ds = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show line diagnostics" },
		dl = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Show loclist" },
		df = { "<cmd>lua vim.lsp.diagnostic.float()<CR>", "Float" },
		dn = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Go to Next" },
		dp = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Go to Prev" },
	},
	c = {
		name = "Comment",
		l = { name = "Line" },
	},
	t = {
		name = "Terminal",
		h = { toggle_horizontal, "Horizontal Terminal" },
		f = { toggle_float, "Float Terminal" },
		l = { toggle_lazygit, "LazyGit" },
		p = { toggle_python, "Python" },
	},
}

local opts = { prefix = "<leader>" }

wk.register(mappings, opts)
