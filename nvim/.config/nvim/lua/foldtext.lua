vim.o.foldtext = ""
vim.o.termguicolors = true
vim.o.laststatus = 3

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = true
vim.o.foldlevelstart = 99
vim.o.foldcolumn = "1"

function _G.HighlightedFoldtext()
	local start = vim.v.foldstart
	local end_ = vim.v.foldend
	local folded_lines = end_ - start + 1

	-- Get the first row of the fold
	local line = vim.api.nvim_buf_get_lines(0, start - 1, start, false)[1] or ""

	-- Treesitter highlight for first row
	local ft = vim.bo.filetype
	local lang = vim.treesitter.language.get_lang(ft)
	local parser = vim.treesitter.get_parser(0, lang)
	local query = vim.treesitter.query.get(parser:lang(), "highlights")

	if not query then
		-- fallback: no syntax highlighting
		return line .. ("  ↙ %d"):format(folded_lines)
	end

	local tree = parser:parse({ start - 1, start })[1]
	local row = start - 1
	local highlights = {}
	local line_pos = 0

	for id, node in query:iter_captures(tree:root(), 0, row, start) do
		local name = query.captures[id]
		local srow, scol, erow, ecol = node:range()
		if srow == row and erow == row then
			if scol > line_pos then
				table.insert(highlights, { line:sub(line_pos + 1, scol), "Folded" })
			end
			local text = vim.treesitter.get_node_text(node, 0)
			table.insert(highlights, { text, "@" .. name })
			line_pos = ecol
		end
	end
	-- remainder after last token
	if line_pos < #line then
		table.insert(highlights, { line:sub(line_pos + 1), "Folded" })
	end

	-- Add fold line number at the end
	table.insert(highlights, { ("  ↙ %d"):format(folded_lines), "FoldedCount" })

	-- RETURN highlight list, NOT string!
	return highlights
end

vim.api.nvim_set_hl(0, "FoldedCount", { fg = "#7aa2f7", bg = "NONE", italic = true, bold = true })
vim.opt.foldtext = "v:lua.HighlightedFoldtext()"
-- This way, Neovim will NOT insert itself... anymore!
-- Make sure fillchars doesn't have folds!
vim.opt.fillchars:append({ fold = " " }) -- dspaces instead of periods
