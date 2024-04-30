-- disable netrw at the very start of your init.lua

require('options').setup()
local bindings = require('bindings')
bindings.setup_early({})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

local telescope_builtin = require("telescope.builtin")

local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"lua", "javascript", "typescript", "ruby", "python"},
  highlight = { enabled = true },
  indent = { enabled = true },
})

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

require('Comment').setup()

bindings.setup_late({telescope_builtin = telescope_builtin})
