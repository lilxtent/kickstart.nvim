-- neotest: run/debug tests from within Neovim
-- https://github.com/nvim-neotest/neotest
--
-- Configured with the Go adapter, wired up to nvim-dap-go (see debug.lua)
-- for "debug nearest test" support.

vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/fredrikaverpil/neotest-golang',
}

require('neotest').setup {
  adapters = {
    require 'neotest-golang' {},
  },
}

vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run() end, { desc = '[T]est: run neares[t]' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, { desc = '[T]est: run [f]ile' })
vim.keymap.set('n', '<leader>td', function() require('neotest').run.run { strategy = 'dap' } end, { desc = '[T]est: [d]ebug nearest' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = '[T]est: toggle [s]ummary' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output.open { enter = true } end, { desc = '[T]est: show [o]utput' })
vim.keymap.set('n', '<leader>tO', function() require('neotest').output_panel.toggle() end, { desc = '[T]est: toggle [O]utput panel' })
