return {
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					numbers = "none",
					close_command = "bdelete! %d",
					right_mouse_command = "bdelete! %d",
					left_mouse_command = "buffer %d",
					middle_mouse_command = nil,

					indicator = {
						icon = "▎",
						style = "icon",
					},

					buffer_close_icon = "󰅖",
					modified_icon = "%#DiagnosticHint#●%*",
					close_icon = "",
					show_buffer_close_icons = true,
					show_close_icon = true,

					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,

					offsets = {
						{
							filetype = "neo-tree",
							text = "󰙅 File Explorer",
							highlight = "Directory",
							text_align = "left",
						},
					},

					separator_style = "slant",
					always_show_bufferline = true,
					custom_areas = {
						left = function()
							local result = {}
							for _, buf in ipairs(vim.api.nvim_list_bufs()) do
								if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "modified") then
									table.insert(result, { text = " ● Unsaved", fg = "#f7768e" })
									break
								end
							end
							return result
						end,
					},
				},
			})
		end,
	},

	{
		"hiphish/rainbow-delimiters.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = "rainbow-delimiters.strategy.global",
					vim = "rainbow-delimiters.strategy.local",
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterViolet",
					"RainbowDelimiterBlue",
					"RainbowDelimiterCyan",
					"RainbowDelimiterGreen",
					"RainbowDelimiterYellow",
					"RainbowDelimiterOrange",
					"RainbowDelimiterRed",
				},
			}

			local colors = {
				Violet = "#ffd700",
				Blue = "#da70d6",
				Cyan = "#87cefa",
				Green = "#32cd32",
				Yellow = "#ffa500",
				Orange = "#00ced1",
				Red = "#ff69b4",
			}

			for name, hex in pairs(colors) do
				vim.api.nvim_set_hl(0, "RainbowDelimiter" .. name, { fg = hex })
			end
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			-- "NeogitOrg/neogit",
			-- "sindrets/diffview.nvim",
		},
		config = function()
			local function safe_require(name)
				local ok, mod = pcall(require, name)
				return ok and mod or nil
			end

			local neogit = safe_require("neogit")
			local diffview = safe_require("diffview")

			local function toggle_neogit()
				if not neogit then
					return
				end
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype:find("^Neogit") then
						vim.api.nvim_win_close(win, false)
						return
					end
				end
				neogit.open({ kind = "tab" })
			end

			require("lualine").setup({
				options = {
					theme = "vscode",
					icons_enabled = true,
					globalstatus = true,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "alpha", "dashboard", "neo-tree" } },
				},
				sections = {
					lualine_a = { { "mode", icon = "" } },
					lualine_b = {
						{
							"branch",
							icon = "",
							on_click = toggle_neogit,
							cond = function()
								return neogit ~= nil
							end,
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							on_click = function()
								diffview.open()
							end,
						},
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
						},
					},
					lualine_c = {
						{
							"filename",
							path = 1,
							symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
						},
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_c = { "filename" },
					lualine_x = { "location" },
				},
				extensions = { "neo-tree", "fugitive", "toggleterm", "lazy", "quickfix", "fzf" },
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		opts = {
			indent = {
				char = "▏", -- Thiner, not suitable when enable scope
				tab_char = "▏",
			},
			scope = {
				-- Rely on treesitter, bad performance
				enabled = false,
				-- highlight = highlight,
			},
		},
		config = function(_, opts)
			local ibl = require("ibl")
			local hooks = require("ibl.hooks")

			ibl.setup(opts)
			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

			-- Hide first level indent, using `foldsep` to show it
			hooks.register(hooks.type.VIRTUAL_TEXT, function(_, _, _, virt_text)
				if virt_text[1] and virt_text[1][1] == opts.indent.char then
					virt_text[1] = { " ", { "@ibl.whitespace.char.1" } }
				end
				return virt_text
			end)
		end,
	},
}
