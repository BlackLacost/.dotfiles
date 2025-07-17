require("toggleterm").setup({
	open_mapping = "<c-t>",
	size = 13,
	shell = vim.fn.has("win32") == 1 and "pwsh" or "/usr/bin/bash",
	shade_terminals = true,
	start_in_insert = true,
	direction = "horizontal",
})
