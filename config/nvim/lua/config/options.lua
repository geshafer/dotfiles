vim.g.is_posix = 1                -- treat default shell as posix compatible

vim.opt.number = true             -- Show line numbers
vim.opt.numberwidth = 5           -- Give 5 characters of space for line numbers

vim.opt.textwidth = 120           -- Reasonable terminal width
vim.opt.colorcolumn = "+1"        -- Show reasonable terminal width
vim.opt.wrap = false              -- Turn off line wrapping

vim.opt.guicursor = "i:block"     -- Use block cursor in input mode
vim.opt.scrolloff = 3             -- Show 3 lines of context around the cursor

vim.opt.history = 50              -- Only store 50 :commands in history
vim.opt.wildmode = "list:longest" -- Expand :command options on tab-complete

vim.opt.title = true              -- Set the terminal's title
vim.opt.visualbell = true         -- No beeping.
vim.opt.splitbelow = true         -- :sp adds new pane below
vim.opt.splitright = true         -- :vs adds new pane to the right
vim.opt.modeline = false          -- don't use insecure embedded vim code
vim.opt.mouse = ""                -- disable mouse movement



-- Remap space to center on current line
vim.api.nvim_set_keymap('n', '<space>', 'zz', {})



-- Persistent undo history
vim.opt.undodir = vim.fn.stdpath('config') .. "/undo/"
vim.opt.undofile = true



-- Soft Tabs
vim.opt.expandtab = true  -- Tabs always convert to spaces
vim.opt.tabstop = 2       -- Tabs are 2 spaces wide
vim.opt.shiftwidth = 2    -- Shifting lines moves them a tab width
vim.opt.shiftround = true -- Shifting lines rounds to the nearest tab width
vim.opt.list = true       -- Display extra whitespace...
vim.opt.listchars = {     -- ...using these characters
  tab = '»·',
  trail = '·',
  nbsp = '·',
}



-- Quicker window movement
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})



-- Sane searching
vim.api.nvim_set_keymap('n', '/', '/\\v', {noremap = true})
vim.api.nvim_set_keymap('v', '/', '/\\v', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader><space>', ':noh<cr>', {noremap = true}) -- Clear search results
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true  -- unless expression contains a capital
vim.opt.hlsearch = true   -- Highlight all matches
vim.opt.incsearch = true  -- Highlight matches as you type



-- Send all vim registers to the mac clipboard
vim.opt.clipboard = "unnamedplus"
if(vim.env.SPIN == "1")
then
  vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
      ["+"] = 'pbcopy',
      ["*"] = 'pbcopy',
    },
    paste = {
      ["+"] = 'pbpaste',
      ["*"] = 'pbpaste',
    },
    cache_enabled = 1
  }
end
