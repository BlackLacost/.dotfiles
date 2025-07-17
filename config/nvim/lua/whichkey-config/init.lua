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

local open_in_browser = function()
	if vim.fn.has("win32") == 1 then
		return vim.cmd(":execute ':silent !chrome.exe %'")
	end

	return vim.cmd(":execute ':silent !wslview %'")
end

local mappings = {
	b = { ":Telescope buffers<cr>", "Telescope Buffers" },
	e = { ":NvimTreeToggle<cr>", "Nvim Tree Toggle" },
	E = { ":e ~/.config/nvim/init.lua<cr>", "Edit config" },
	f = { ":Telescope find_files<cr>", "Telescope Find Files" },
	g = { ":Telescope live_grep<cr>", "Telescope Live Grep" },
	o = { open_in_browser, "Open in Browser" },
	q = { ":wqall<cr>", "Save All & Quit" },
	Q = { ":q<cr>", "Quit" },
	R = { ":Telescope resume<cr>", "Telescope Resume" },
	s = { ":wall<cr>", "Save All" },
	S = { ":w<cr>", "Save" },
	x = { ":bdelete<cr>", "Close Current Buffer" },
	c = {
		name = "Comment",
		l = { name = "Line" },
	},
	d = {
		name = "Diagnostic",
		f = { "<cmd>lua vim.lsp.diagnostic.float()<CR>", "Float" },
		l = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Show loclist" },
		n = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Go to Next" },
		p = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Go to Prev" },
		s = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show line diagnostics" },
	},
	D = {
		name = "Database",
		e = { ":DBUIToggle<CR>", "DB UI Toggle" },
		f = { ":DBUIFindBuffer<CR>", "DB Find Buffer" },
		r = { ":DBUIRenameBuffer<CR>", "DB Rename Buffer" },
		l = { ":DBUILastQueryInfo<CR>", "DB Last Query Info" },
	},
	h = {
		name = "Git Signs",
		b = { "Blame" },
		p = { "Preview Hunk" },
		r = { "Reset Hunk" },
		R = { "Reset Buffer" },
		s = { "Stage Hunk" },
		S = { "Stage Buffer" },
		u = { "Undo Stage Hunk" },
		U = { "Reset Buffer Index" },
	},
	l = {
		name = "LSP",
		d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
		D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
		f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Formatting" },
		h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
		i = { ":LspInfo<cr>", "Connected Language Servers" },
		I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
		l = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
		s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature" },
		t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
	},
	r = {
		name = "Refactoring",
		a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions" },
		j = { "Doc generator" },
		r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
	},
	t = {
		name = "Terminal",
		f = { toggle_float, "Float Terminal" },
		h = { toggle_horizontal, "Horizontal Terminal" },
		l = { toggle_lazygit, "LazyGit" },
		p = { toggle_python, "Python" },
	},
	w = {
		name = "Workspace",
		a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder" },
		l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List workspace folder" },
		r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder" },
	},
	z = {
		name = "Telekasten",
		a = { ":lua require('telekasten').show_tags()<CR>", "Show Tags" },
		b = { ":lua require('telekasten').show_backlinks()<CR>", "Show Backlinks" },
		c = { ":lua require('telekasten').show_calendar()<CR>", "Show Calendar" },
		C = { ":CalendarT<CR>", "Calendar T" },
		d = { ":lua require('telekasten').find_daily_notes()<CR>", "Find Daily Notes" },
		f = { ":lua require('telekasten').find_notes()<CR>", "Find Notes" },
		F = { ":lua require('telekasten').find_friends()<CR>", "Find Friends" },
		g = { ":lua require('telekasten').search_notes()<CR>", "Search in Notes" },
		i = { ":lua require('telekasten').paste_img_and_link()<CR>", "Paste Image & Link" },
		I = { ":lua require('telekasten').insert_img_link({ i=true })<CR>", "Insert Image Link" },
		m = { ":lua require('telekasten').browser_media()<CR>", "Browser Media" },
		n = { ":lua require('telekasten').new_note()<CR>", "New Note" },
		N = { ":lua require('telekasten').new_templated_note()<CR>", "New Templated Note" },
		p = { ":lua require('telekasten').panel()<CR>", "Panel" },
		P = { ":lua require('telekasten').preview_img()<CR>", "Preview Image" },
		t = { ":lua require('telekasten').toggle_todo()<CR>", "Toggle Todo" },
		T = { ":lua require('telekasten').goto_today()<CR>", "Goto Today" },
		w = { ":lua require('telekasten').find_weekly_notes()<CR>", "Find Weekly Notes" },
		W = { ":lua require('telekasten').goto_thisweek()<CR>", "Goto this Week" },
		y = { ":lua require('telekasten').yank_notelink()<CR>", "Yank Notelink" },
		z = { ":lua require('telekasten').follow_link()<CR>", "Follow Link" },
	},
}

local opts = { prefix = "<leader>" }

wk.register(mappings, opts)
