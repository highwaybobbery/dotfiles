---@class CustomModule
local Bindings = {
  setup_early = function()
    vim.g.mapleader = ' '
  end,

  setup_late = function()
    vim.keymap.set('n', '<C-l>', '<c-w>l', { noremap=true, silent=true })
    vim.keymap.set('n', '<C-h>', '<c-w>h', { noremap=true, silent=true })
    vim.keymap.set('n', '<C-k>', '<c-w>k', { noremap=true, silent=true })
    vim.keymap.set('n', '<C-j>', '<c-w>j', { noremap=true, silent=true })


    vim.keymap.set('n', '<C-p>', ':set past<cr>', { noremap=true })
    vim.keymap.set('n', '<leader><space>', ':noh<return><esc>', { noremap=true })
    vim.keymap.set('n', '<leader>q', ':q<return>', { noremap=true })
    --vim.keymap.set('n', ',', '/', { noremap=true })

    -- NeoTree 
    vim.keymap.set('n', '<leader>tt', '<Cmd>Neotree toggle left<CR>', { noremap=true, desc="Toggle File Tree" })
    vim.keymap.set('n', '<leader>tb', '<Cmd>Neotree source=buffers toggle left<CR>', { noremap=true, desc="Toggle Buffer List" })

    -- Telescope
    local builtin = require("telescope.builtin")

    vim.keymap.set('n', '<leader>lf',  builtin.find_files, { desc="Telescope Find Files" })
    vim.keymap.set('n', '<leader>lg',  builtin.live_grep, { desc="Telescope Grep" })
    vim.keymap.set('n', '<leader>lk',  builtin.keymaps, { desc="Telescope Keymaps" })

    -- neotest
    -- vim.keymap.set('n', '<leader>rn', ''  { noremap=true })

    -- vim-tmux-navigator
    vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { silent = true })
    vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { silent = true })
    vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true })
    vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { silent = true })
    vim.keymap.set("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", { silent = true })
    vim.keymap.set("n", "<C-Space>", "<Cmd>NvimTmuxNavigateNavigateNext<CR>", { silent = true })

    -- LSP
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

    -- Other
    vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>:Other<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>ot", "<cmd>:Other test<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>otv", "<cmd>:OtherVSplit test<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>os", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>ov", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>oc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })
    -- Context specific bindings

    -- fugitive
    vim.api.nvim_set_keymap("n", "<leader>gg", ":Git<cr>", {silent = true})
    vim.api.nvim_set_keymap("n", "<leader>ga", ":Git add %:p<cr><cr>", {silent = true})
    vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiff<cr>", {silent = true})
    vim.api.nvim_set_keymap("n", "<leader>ge", ":Gedit<cr>", {silent = true})
    vim.api.nvim_set_keymap("n", "<leader>gw", ":Gwrite<cr>", {silent = true})
    vim.api.nvim_set_keymap("n", "<leader>gf", ":Commits<cr>", {silent = true})
  end
}
return Bindings
