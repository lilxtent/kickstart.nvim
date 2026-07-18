-- Claude Code integration for Neovim
vim.pack.add { 'coder/claudecode.nvim' }
require('claudecode').setup {
  ui = {
    keep_status_line = true,
  },
}

-- Set up keymaps for Claude Code
local map = vim.keymap.set

-- Group for which-key documentation
require('which-key').add {
  { '<leader>a', group = 'AI/Claude Code' },
}

-- Main commands and navigation
map('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = 'Resume Claude' })
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude' })
map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Claude model' })

-- Buffer and file operations
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer' })
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send to Claude' })

-- File explorer context (neo-tree, oil, etc.)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw', 'snacks_picker_list' },
  callback = function() map('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { desc = 'Add file', buffer = 0 }) end,
})

-- Diff management
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })
