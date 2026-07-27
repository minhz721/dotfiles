return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			-- size = 20,
			direction = "float",
			start_in_insert = true,
		})

		-- Toggle terminal (float)
		vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
		vim.keymap.set("t", "<leader>t", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "Toggle Terminal" })
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })
		vim.keymap.set("t", "<leader>q", [[<C-\><C-n>:bd!<CR>]], { desc = "Quit Terminal (close buffer)" })

		-- Run current file with F6
		vim.keymap.set("n", "<F6>", function()
			local ft = vim.bo.filetype
			local file = vim.fn.expand("%")
			local bin = vim.fn.expand("%:t:r")

			local cmd = {
				python = "python3 " .. file,
				javascript = "node " .. file,
				typescript = "ts-node " .. file,
				sh = "bash " .. file,
				go = "go run " .. file,
				c = string.format("gcc %s -o /tmp/%s && /tmp/%s", file, bin, bin),
			}

			local run = cmd[ft]
			if run then
				require("toggleterm.terminal").Terminal
					:new({
						cmd = run,
						direction = "float",
						close_on_exit = false,
					})
					:toggle()
			else
				vim.notify("⚠ No run command for filetype: " .. ft, vim.log.levels.WARN)
			end
		end, { desc = "󰑊 Run Current File" })
	end,
}