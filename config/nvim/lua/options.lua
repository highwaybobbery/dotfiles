---@class CustomModule
local Options = {

  setup_early = function()
    vim.g.mapleader = ' '
  end,

  setup = function(opts)
    opts = opts or {}

    -- vim.g.loaded_netrw = 1
    -- vim.g.loaded_netrwPlugin = 1

    vim.opt.backspace = '2'
    vim.opt.backup = false
    vim.opt.colorcolumn = '80'
    vim.opt.expandtab = true
    vim.opt.nu = true
    vim.opt.number = true
    vim.opt.relativenumber = false
    vim.opt.scrolloff = 10
    vim.opt.shiftwidth = 2
    vim.opt.signcolumn = "number"
    vim.opt.swapfile = false
    vim.opt.tabstop = 2
    vim.opt.title = true
    vim.opt.wb = false
    vim.opt.foldmethod = "syntax"
    vim.opt.foldenable = false


    vim.api.nvim_set_option("clipboard","unnamed")
  end,
}

return Options
