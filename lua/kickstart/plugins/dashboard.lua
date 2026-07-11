-- dashboard-nvim: a start screen shown when Neovim is opened with no file arguments
-- https://github.com/nvimdev/dashboard-nvim

vim.pack.add {
  'https://github.com/nvimdev/dashboard-nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

require('dashboard').setup {
  theme = 'doom',
  config = {
    header = {
      '',
      'Neovim',
      '',
    },
    center = {
      { icon = '  ', desc = 'Find File', key = 'f', action = 'Telescope find_files' },
      { icon = '  ', desc = 'Recently Used Files', key = 'r', action = 'Telescope oldfiles' },
      { icon = '  ', desc = 'Find Word', key = 'g', action = 'Telescope live_grep' },
      { icon = '  ', desc = 'File Browser', key = 'e', action = 'Neotree reveal' },
      { icon = '  ', desc = 'Quit', key = 'q', action = 'qa' },
    },
    footer = {},
  },
}
