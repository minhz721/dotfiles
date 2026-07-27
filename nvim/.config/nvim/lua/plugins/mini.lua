return {
	-- auto close pair
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		version = false,
		config = function()
			require("mini.pairs").setup({
				mappings = {
					["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
					[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
					["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
					["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
					["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
					["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

					["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
					[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },

					['"'] = { action = "open", pair = '""', neigh_pattern = "[^\\]." },
					["'"] = { action = "open", pair = "''", neigh_pattern = "[^%a\\]." },
					["`"] = { action = "open", pair = "``", neigh_pattern = "[^\\]." },
				},
			})
		end,
	},

	-- comment
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		config = function()
			local comment = require("mini.comment")
			comment.setup({
				options = {
					ignore_blank_line = true,
					pad_comment_parts = true,
				},
				mappings = {
					comment = "gc",
					comment_line = "gcc",
					comment_visual = "gc",
					textobject = "gc",
				},
			})

			-- Toggle comment
			local toggle = function()
				local count = vim.v.count or 1
				vim.cmd("norm " .. count .. "gcc")
			end

			vim.keymap.set({ "n", "x", "o" }, "<leader>/", toggle, {
				remap = true,
				desc = "[/] Toggle comment (VSCode style)",
			})
		end,
	},

	{
		"echasnovski/mini.hipatterns",
		config = function()
			require("mini.hipatterns").setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

					-- Highlight hex color strings (`#rrggbb`) using that color
					hex = require("mini.hipatterns").gen_highlighter.hex_color(),
				},
			})
		end,
	},

	-- {
	-- 	"echasnovski/mini.indentscope",
	-- 	version = false,
	-- 	event = "BufReadPost",
	-- 	opts = {
	-- 		symbol = "│",
	-- 		options = { try_as_border = true },
	-- 	},
	-- 	config = function(_, opts)
	-- 		local m = require("mini.indentscope")

	-- 		-- Disable for specific filetypes
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			pattern = {
	-- 				"neo-tree",
	-- 				"neotree",
	-- 				"NvimTree",
	-- 				"lazy",
	-- 				"help",
	-- 				"dashboard",
	-- 			},
	-- 			callback = function()
	-- 				vim.b.miniindentscope_disable = true
	-- 			end,
	-- 		})

	-- 		m.setup(opts)

	-- 		local colors = { "#E06C75", "#E5C07B", "#98C379", "#56B5C1", "#61AFEF", "#C678DD" }
	-- 		vim.api.nvim_set_hl(0, "MiniIndentScopeSymbol", { fg = colors[1] })
	-- 	end,
	-- },
}
