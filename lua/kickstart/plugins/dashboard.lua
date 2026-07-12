-- snacks.nvim dashboard: a start screen shown when Neovim is opened with no file arguments
-- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md

vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = ' ', key = 'f', desc = 'Find File', action = function() Snacks.dashboard.pick 'files' end },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = function() Snacks.dashboard.pick 'oldfiles' end },
        { icon = ' ', key = 'g', desc = 'Find Word', action = function() Snacks.dashboard.pick 'live_grep' end },
        { icon = ' ', key = 'e', desc = 'File Browser', action = '<Cmd>Neotree reveal<CR>' },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    -- "compact_files" example from the docs, minus the `startup` section,
    -- which assumes lazy.nvim (for load-time stats) and errors under vim.pack.
    sections = {
      { section = 'header' },
      { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
      { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
    },
  },
}
