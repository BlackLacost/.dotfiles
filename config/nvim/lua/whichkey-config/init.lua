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
	l = {
		name = "LSP",
		i = { ":LspInfo<cr>", "Connected Language Servers" },
		A = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder" },
		R = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder" },
		l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List workspace folder" },
		D = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
		r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
		a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions" },
		e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show line diagnostics" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Show loclist" },
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
