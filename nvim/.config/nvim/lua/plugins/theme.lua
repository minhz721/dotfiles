return {
	{
		"Mofiqul/vscode.nvim",
		priority = 1000,
		config = function()
			local vscode = require("vscode")
			vscode.setup({
				italic_comments = true,
				disable_nvimtree_bg = true,
			})
			vscode.load("dark")
		end,
	},
}
