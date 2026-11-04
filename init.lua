vim.opt.termguicolors = true -- enable true color support
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a" -- enable mouse
vim.opt.clipboard = "unnamedplus" -- sync clipboard b/w OS and nvim
vim.opt.undofile = true -- save undo history make a hidden .un~ file
vim.opt.signcolumn = "yes" -- Always keep a space for signs (error, warnings, Git markers, etc.) on the left side of the editor.
vim.opt.breakindent = true -- keeps wrapped lines visually aligned with original indent line
vim.opt.wrap = true -- line wrapping 

vim.opt.inccommand = "split" -- :%s/{what to change}/{change with}/g replace with {change with} 
-- [[
-- % -> entire file
-- s -> substituate/replace
-- g -> replace all matches on each line
-- ]]

vim.opt.cursorline = true -- show which line cursor is on
vim.opt.hlsearch = true -- Highlight all matches result when search something with / or ? i.e /{what to search} to remove the highlights :nohlsearch
vim.opt.shiftwidth = 4

vim.pack.add ({
    {
	-- for communication with LSP
	src = 'https://github.com/neovim/nvim-lspconfig'
    },
    {
	-- for syntax highlighting
	src = 'https://github.com/nvim-treesitter/nvim-treesitter', 
	version = 'main'
    },
    {
	-- for code auto complete
	src = 'https://github.com/saghen/blink.cmp',
	version = vim.version.range('1.*'),
    },
    {
	-- for git
	src = 'https://github.com/lewis6991/gitsigns.nvim'
    },
    {
	-- for cosmetic i.e theme 
	src = 'https://github.com/folke/tokyonight.nvim', 
	name = 'tokyonight'
    },
    {
	-- for auto LSP download
	src = 'https://github.com/mason-org/mason.nvim'
    },
})

-- For Syntax 
require('nvim-treesitter').install ({
    'lua', 'c', 'python', 'rust' -- add lang if needed
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'lua', 'c', 'python', 'rust'},
    callback = function()
	pcall(vim.treesitter.start)
    end,
})

-- For autocomplete
require('blink.cmp').setup ({
    keymap = {preset = 'super-tab'}, -- like arrows + tab in VSCode
    sources = {
	default = {'lsp', 'path', 'buffer'},
    },
    completion = {
	documentation = {auto_show = true},
    },
})
-- Auto popup when cursor sits on error line
vim.o.updatetime = 300 -- to fetch faster
vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
	vim.diagnostic.open_float(nil, {focus = false})
    end,
})

-- For LSP 
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.enable({'clangd','rust_analyzer','pyright'}) -- add lang what you need

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
	local opts = {buffer = args.buf}
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) 
    end,
})

-- For theme 
vim.cmd.colorscheme('tokyonight')

-- For Git
require('gitsigns').setup ({
    current_line_blame = true
})

-- For Mason 
require("mason").setup()
