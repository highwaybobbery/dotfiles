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

    vim.keymap.set('v', '<C-r>', "hy:%s/<C-r>h//gc<left><left><left>", { noremap=true })


    vim.keymap.set('n', '<C-p>', ':set past<cr>', { noremap=true })
    vim.keymap.set('n', '<leader><space>', ':noh<return><esc>', { noremap=true })
    vim.keymap.set('n', '<leader>q', ':q<return>', { noremap=true })
    --vim.keymap.set('n', ',', '/', { noremap=true })

    -- NeoTree 
    vim.keymap.set('n', '<leader>tt', '<Cmd>Neotree source=filesystem toggle left<CR>', { noremap=true, desc="Toggle File Tree" })
    vim.keymap.set('n', '<leader>tb', '<Cmd>Neotree source=buffers toggle left<CR>', { noremap=true, desc="Toggle Buffer List" })
    vim.keymap.set('n', '<leader>tg', '<Cmd>Neotree source=git_status toggle left<CR>', { noremap=true, desc="Toggle Git Status" })

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
    vim.keymap.set('n', '<leader>kh', vim.lsp.buf.hover, {desc="LSP Hover" })
    vim.keymap.set('n', '<leader>ka', vim.lsp.buf.code_action, { desc="LSP Code Actions" })
    vim.keymap.set('n', '<leader>ki', vim.lsp.buf.implementation, { desc="LSP Implementation" })
    vim.keymap.set('n', '<leader>kci', vim.lsp.buf.incoming_calls, { desc="LSP Incoming Calls"})
    vim.keymap.set('n', '<leader>kco', vim.lsp.buf.outgoing_calls, { desc="LSP Outgoing Calls" })
    vim.keymap.set('n', '<leader>krf', vim.lsp.buf.references, { desc="LSP References" })
    vim.keymap.set('n', '<leader>krn', vim.lsp.buf.rename, { desc = "LSP Rename" })

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
