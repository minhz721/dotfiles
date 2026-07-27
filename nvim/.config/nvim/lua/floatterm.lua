-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- local state = {
-- 	floating = {
-- 		buf = -1,
-- 		win = -1,
-- 	},
-- }

-- -- Create a new floating window centered on the screen
-- local function create_floating_window(opts)
-- 	opts = opts or {}
-- 	local width = opts.width or math.floor(vim.o.columns * 0.8)
-- 	local height = opts.height or math.floor(vim.o.lines * 0.8)

-- 	local col = math.floor((vim.o.columns - width) / 2)
-- 	local row = math.floor((vim.o.lines - height) / 2)

-- 	-- Always create a new buffer to avoid reuse and bugs with terminal buffers
-- 	local buf = vim.api.nvim_create_buf(false, true)

-- 	local win_config = {
-- 		relative = "editor",
-- 		width = width,
-- 		height = height,
-- 		col = col,
-- 		row = row,
-- 		style = "minimal",
-- 		border = "rounded",
-- 	}

-- 	local win = vim.api.nvim_open_win(buf, true, win_config)

-- 	return { buf = buf, win = win }
-- end

-- -- Open the floating terminal if not already open
-- local function open_terminal_if_needed()
-- 	if not vim.api.nvim_win_is_valid(state.floating.win) then
-- 		state.floating = create_floating_window()
-- 		-- Create terminal directly in the newly created buffer
-- 		local shell = vim.o.shell or os.getenv("SHELL") or "/bin/sh"
-- 		vim.fn.termopen(shell)
-- 		vim.api.nvim_buf_set_option(state.floating.buf, "bufhidden", "wipe")
-- 		vim.cmd("startinsert")
-- 	end
-- end

-- -- Toggle the floating terminal window
-- local function toggle_terminal()
-- 	if not vim.api.nvim_win_is_valid(state.floating.win) then
-- 		open_terminal_if_needed()
-- 	else
-- 		vim.api.nvim_win_hide(state.floating.win)
-- 	end
-- end

-- vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

-- vim.keymap.set({ "n", "t" }, "<leader>t", toggle_terminal, { desc = "Toggle floating terminal" })

-- vim.keymap.set({ "n", "t" }, "<leader>q", function()
-- 	if vim.api.nvim_win_is_valid(state.floating.win) then
-- 		vim.api.nvim_win_hide(state.floating.win)
-- 	end
-- end, { desc = "Close floating terminal" })

-- -- Run the current file in the floating terminal based on its filetype
-- local function run_current_file()
-- 	local file = vim.fn.expand("%:p")
-- 	local ext = vim.fn.expand("%:e")
-- 	local cmd = nil
-- 	if ext == "py" then
-- 		cmd = "python3 " .. file
-- 	elseif ext == "js" then
-- 		cmd = "node " .. file
-- 	elseif ext == "ts" then
-- 		cmd = "ts-node " .. file
-- 	elseif ext == "c" then
-- 		cmd = "gcc " .. file .. " -o /tmp/a.out && /tmp/a.out"
-- 	else
-- 		print("File extension ." .. ext .. " is not supported")
-- 		return
-- 	end

-- 	open_terminal_if_needed()

-- 	if vim.api.nvim_win_is_valid(state.floating.win) and vim.api.nvim_buf_is_valid(state.floating.buf) then
-- 		local ok, _ = pcall(function()
-- 			vim.api.nvim_set_current_win(state.floating.win)
-- 			vim.cmd("startinsert")
-- 			-- Get the job_id of the current terminal buffer (must match the buffer!)
-- 			local bufnr = state.floating.buf
-- 			local job = vim.b[bufnr] and vim.b[bufnr].terminal_job_id or nil
-- 			if job then
-- 				vim.fn.chansend(job, cmd .. "\n")
-- 			else
-- 				print("Cannot find terminal job_id")
-- 			end
-- 		end)
-- 		if not ok then
-- 			print("Failed to send command to terminal.")
-- 		end
-- 	else
-- 		print("Floating terminal is not open!")
-- 	end
-- end

-- vim.keymap.set("n", "<F6>", run_current_file, { desc = "Run current file in floating terminal" })