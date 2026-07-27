-- Set leader key
vim.g.mapleader = " "

-- Enable mouse
vim.opt.mouse = "a"

-- Clear search highlight with <leader>h
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

-- Show absolute line numbers
vim.wo.number = true

-- Enable line wrap like VSCode
vim.opt.wrap = true

-- Enable spell checking
vim.opt.spell = true

-- Set UTF-8 encoding
vim.opt.encoding = "utf-8"

-- Enable absolute and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tab and indentation settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Keep line wrap but disable automatic line breaking
vim.opt.formatoptions:remove("t")

-- Search settings: case insensitive unless uppercase used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable swap and backup files; enable persistent undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Search UI behavior
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable 24-bit true color
vim.opt.termguicolors = true

-- Always show sign column
vim.opt.signcolumn = "yes"

-- Scroll context around cursor
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Allow @ character in file names
vim.opt.isfname:append("@-@")

-- Faster plugin response time
vim.opt.updatetime = 50

vim.opt.termguicolors = true

vim.o.mouse = "a"

-- Highlight search
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.scrolloff = 1
vim.o.sidescroll = 1
vim.o.showcmd = true

vim.o.cursorline = true

-- Auto format
vim.g.autoformat = true

vim.opt.cursorline = true

