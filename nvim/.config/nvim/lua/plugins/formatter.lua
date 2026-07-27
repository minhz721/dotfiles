-- return {
--     { -- Autoformat
--         "stevearc/conform.nvim",
--         event = { "BufWritePre" },
--         cmd = { "ConformInfo" },
--         keys = {
--             {
--                 "<leader>f",
--                 function()
--                     require("conform").format({ async = true, lsp_format = "fallback" })
--                 end,
--                 mode = "",
--                 desc = "[F]ormat buffer",
--             },
--         },
--         opts = {
--             notify_on_error = false,
--             format_on_save = function(bufnr)
--                 -- Disable "format_on_save lsp_fallback" for languages that don't
--                 -- have a well standardized coding style. You can add additional
--                 -- languages here or re-enable it for the disabled ones.
--                 local disable_filetypes = { c = true, cpp = true }
--                 if disable_filetypes[vim.bo[bufnr].filetype] then
--                     return nil
--                 else
--                     return {
--                         timeout_ms = 500,
--                         lsp_format = "fallback",
--                     }
--                 end
--             end,
--             formatters_by_ft = {
--                 javascript = { "prettier" },
--                 typescript = { "prettier" },
--                 html = { "prettier" },
--                 css = { "prettier" },
--                 json = { "prettier" },
--                 yaml = { "prettier" },
--                 python = { "black" },
--                 c = { "clang_format" },
--                 cpp = { "clang_format" },
--                 lua = { "stylua" },
--                 sh = { "shfmt" },
--             },
--         },
--     },
-- }

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = {},
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				vue = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				python = { "black" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				lua = { "stylua" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
			},
		},
	},
	{
		"zapling/mason-conform.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },
		config = function()
			require("mason-conform").setup({
				ensure_installed = {
					"prettier",
					"black",
					"clang-format",
					"stylua",
					"shfmt",
				},
			})
		end,
	},

	-- {
	-- 	-- nvim-lint: Linter integration
	-- 	"mfussenegger/nvim-lint",
	-- 	event = { "BufReadPre", "BufWritePost" },
	-- 	config = function()
	-- 		require("lint").linters_by_ft = {
	-- 			javascript = { "eslint_d" },
	-- 			typescript = { "eslint_d" },
	-- 			python = { "flake8" },
	-- 			lua = { "luacheck" },
	-- 			sh = { "shellcheck" },
	-- 			bash = { "shellcheck" },
	-- 			zsh = { "shellcheck" },
	-- 			markdown = { "markdownlint" },
	-- 		}
	-- 		-- Tự động lint khi lưu file
	-- 		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	-- 			callback = function()
	-- 				require("lint").try_lint()
	-- 			end,
	-- 		})
	-- 	end,
	-- },
}
