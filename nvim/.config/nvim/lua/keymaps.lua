vim.g.mapleader = " "

-- Map helper with silent=true by default
local function map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quick exit insert
-- map("i", "jk", "<ESC>")

-- Splits
map("n", "<leader>o", "<CMD>vsplit<CR>")
map("n", "<leader>p", "<CMD>split<CR>")

-- Close splits
map("n", "<leader>c", "<CMD>close<CR>", { desc = "Close Current Split" })
map("n", "<leader>co", "<CMD>only<CR>", { desc = "Close Other Splits" })

-- Close buffer / quit
map("n", "<C-w>", "<cmd>bd<cr>", { desc = "Close Current Buffer" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit All" })

-- Save
map("n", "<C-s>", "<cmd>w<CR>")
map("i", "<C-s>", "<Esc><cmd>w<CR>")

-- Select all
map("n", "<C-a>", "ggVG")
map("i", "<C-a>", "<Esc>ggVG")

-- Clear search
-- map("n", "<leader>h", ":nohlsearch<CR>")

-- Window nav
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")

-- System clipboard: copy, cut, paste
map({ "n", "v", "i" }, "<C-c>", function()
	if vim.fn.mode():match("[vV]") then
		vim.cmd('normal! "+y')
	else
		vim.cmd('normal! "+yy')
	end
end, { desc = "󰅍 Copy to clipboard" })

map({ "n", "v", "i" }, "<C-x>", function()
	if vim.fn.mode():match("[vV]") then
		vim.cmd('normal! "+d')
	else
		vim.cmd('normal! "+dd')
	end
end, { desc = "󰅎 Cut to clipboard" })

map({ "n", "v", "i" }, "<C-v>", '"+p', { desc = "󰅏 Paste from clipboard" })

vim.opt.clipboard = "unnamedplus"

-- Undo / Redo
map({ "n", "v" }, "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<Esc>u", { desc = "Undo" })
map("t", "<C-z>", "<C-\\><C-n>u", { desc = "Undo" })

map({ "n", "v" }, "<C-S-z>", "<C-r>", { desc = "Redo" })
map("i", "<C-S-z>", "<Esc><C-r>", { desc = "Redo" })
map("t", "<C-S-z>", "<C-\\><C-n><C-r>", { desc = "Redo" })

-- Duplicate / move lines (Alt + Up/Down)
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "󰜮 Move line up" })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "󰜯 Move line down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "󰜮 Move selection up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "󰜯 Move selection down" })

-- Copy line up/down (Shift + Alt + Up/Down)
map("n", "<S-A-Up>", "yyp", { desc = "󰆐 Copy line above" })
map("n", "<S-A-Down>", "yyP", { desc = "󰆏 Copy line below" })
map("v", "<S-A-Up>", "y`<P`>]", { desc = "󰆐 Copy block above" })
map("v", "<S-A-Down>", "y`>p`<]", { desc = "󰆏 Copy block below" })

-- Delete current line (normal mode)
vim.keymap.set("n", "<C-S-k>", "dd", { noremap = true, desc = "Delete Line" })

-- Delete visual block (visual mode)
vim.keymap.set("v", "<C-S-k>", "d", { noremap = true, desc = "Delete Block" })

-- Duplicate visual block (visual mode)
vim.keymap.set("v", "<C-d>", "y`>p`<]", { noremap = true, desc = "Duplicate Block" })

--Tab/Shift Tab Visual mode
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent line(s)" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Outdent line(s)" })

-- Tab/Shift+Tab normal mode
vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent line" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Outdent line" })

-- Replace char
vim.keymap.set({ "n", "x" }, "<C-h>", function()
	-- Prompt the user to enter the search string
	local search_term = vim.fn.input("Search for (Ctrl+C to cancel): ")
	if search_term == "" then
		-- User pressed Enter without typing anything or pressed Ctrl+C to cancel
		print("Search cancelled.")
		return
	end

	-- Prompt the user to enter the replacement string
	local replace_term = vim.fn.input("Replace with (leave empty for delete): ")
	-- No need to check if replace_term is empty, as replacing with an empty string is valid (deletion)

	local command
	local current_mode = vim.api.nvim_get_mode().mode

	if current_mode == "n" then
		-- In Normal mode: apply substitution to the entire current file (buffer)
		-- %s: Apply substitution to the entire current file
		-- #: Use # as a separator instead of / to avoid issues if search_term/replace_term contain /
		-- gic: global, case-insensitive, confirm
		command = string.format("%%s#%s#%s#gic", search_term, replace_term)
	elseif current_mode == "x" then
		-- In Visual mode: apply substitution only within the selection
		-- '<,'>s: Substitute within the Visual selection
		-- gic: global, case-insensitive, confirm
		command = string.format("'<,'>s#%s#%s#gic", search_term, replace_term)
	else
		-- Fallback or handle other modes if necessary
		print("Find and Replace not supported in current mode.")
		return
	end

	-- Execute the command
	vim.cmd(command)
end, { desc = "Find and Replace (Current File or Selection) with Prompt" })

-- Map <leader>Y to ask for start and end lines to yank
vim.keymap.set("n", "<leader>y", function()
	vim.ui.input({ prompt = "Start line: " }, function(start_line)
		if not start_line then
			return
		end
		vim.ui.input({ prompt = "End line: " }, function(end_line)
			if not end_line then
				return
			end
			local cmd = string.format('normal! %sGV%sG"+y', start_line, end_line)
			vim.cmd(cmd)
			print(string.format("Copied lines %s to %s to clipboard", start_line, end_line))
		end)
	end)
end, { desc = "Copy range of lines to clipboard" })
