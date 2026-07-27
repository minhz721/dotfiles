return {
    -- "nvim-telescope/telescope.nvim",
    -- event = "VeryLazy",
    -- tag = "0.1.8",
    -- dependencies = { "nvim-lua/plenary.nvim" },
    -- opts = {
    --     defaults = {
    --         layout_strategy = "horizontal",
    --         layout_config = { prompt_position = "top" },
    --         sorting_strategy = "ascending",
    --         winblend = 0,
    --     },
    -- },
    -- config = function(_, opts)
    --   local telescope = require("telescope")
    --   local builtin = require("telescope.builtin")

    --   telescope.setup(opts)

    --   -- Keymaps
    --   vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find Files" })
    --   vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live Grep" })
    --   vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
    --   vim.keymap.set("n", "<leader>fp", function()
    --     builtin.find_files({ cwd = require("lazy.core.config").options.root })
    --   end, { desc = "Telescope: Find Plugin File" })
    --   vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
    -- end,
}
