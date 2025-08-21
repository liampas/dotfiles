vim.g.mapleader = ";"



--insert time/date
vim.api.nvim_set_keymap('n', '<leader>d', [[<cmd>lua insert_date()<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>t', [[<cmd>lua insert_time()<CR>]], { noremap = true, silent = true })

function insert_date()
local date = os.date("%y-%m-%d (%H:%M)")
vim.api.nvim_put({date}, 'c', true, true)
end

function insert_time()
local date = os.date("(%H:%M)")
vim.api.nvim_put({date}, 'c', true, true)
end



vim.o.number = true
vim.cmd.syntax("on")
vim.o.hlsearch = true


--- Plugins ---

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')


Plug('nvim-treesitter/nvim-treesitter')
Plug('nvim-tree/nvim-tree.lua')
Plug('uZer/pywal16.nvim', { [ 'as' ] = 'pywal16' })

Plug 'nvim-tree/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'romgrk/barbar.nvim'
vim.call('plug#end')


-- NvimFileTree --

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})
