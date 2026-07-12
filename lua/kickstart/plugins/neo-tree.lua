-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  event_handlers = {
    {
      event = 'file_opened',
      handler = function() require('neo-tree.command').execute { action = 'close' } end,
    },
  },
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
  git_status = {
    window = {
      position = 'float',
    },
  },
}

-- Automatically enable preview mode (see `:h neo-tree-preview-mode`) so files
-- are shown as the cursor moves, without needing to press `P` first.
local preview_enabled_wins = {}
require('neo-tree.events').subscribe {
  event = require('neo-tree.events').AFTER_RENDER,
  handler = function(state)
    if not state.winid or preview_enabled_wins[state.winid] then return end
    preview_enabled_wins[state.winid] = true
    state.config = { use_float = true, use_snacks_image = true, use_image_nvim = true }
    require('neo-tree.sources.common.commands').toggle_preview(state)
  end,
}
