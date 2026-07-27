return {
	-- Core nvim-dap
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			-- Python debug adapter (debugpy)
			dap.adapters.python = {
				type = "executable",
				command = "python",
				args = { "-m", "debugpy.adapter" },
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return "python"
					end,
				},
			}

			-- Debug control keymaps
			local map = vim.keymap.set
			map("n", "<F9>", dap.continue, { desc = "DAP Continue" })
			map("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
			map("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
			map("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
			map("n", "<Leader>b", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
			map("n", "<Leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP Set Conditional Breakpoint" })
			map("n", "<Leader>dr", dap.repl.open, { desc = "DAP Open REPL" })
			map("n", "<Leader>dl", dap.run_last, { desc = "DAP Run Last" })
		end,
	},
	-- nvim-dap-ui
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			-- Auto open/close dapui
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- UI control keymap
			vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP UI Toggle" })
		end,
	},
}

