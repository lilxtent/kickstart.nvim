-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

-- Persist which folders are expanded across restarts, keyed by cwd (assumes
-- filesystem.bind_to_cwd, the default). `force_open_folders` is the same
-- undocumented state field neo-tree itself uses internally to restore open
-- folders after a search (see filesystem/init.lua's reset_search) -- setting
-- it before the tree's first render makes neo-tree recursively load and
-- expand exactly those paths, instead of only marking already-loaded nodes.
local expanded_state_file = vim.fn.stdpath 'state' .. '/neotree-expanded-folders.json'

local function read_expanded_state()
  local ok, lines = pcall(vim.fn.readfile, expanded_state_file)
  if not ok then return {} end
  local ok2, decoded = pcall(vim.json.decode, table.concat(lines, '\n'))
  return ok2 and decoded or {}
end

require('neo-tree').setup {
  event_handlers = {
    {
      event = 'file_opened',
      handler = function() require('neo-tree.command').execute { action = 'close' } end,
    },
    {
      event = 'state_created',
      handler = function(state)
        if state.name ~= 'filesystem' then return end
        local saved = read_expanded_state()[vim.loop.cwd()]
        if saved and #saved > 0 then state.force_open_folders = saved end
      end,
    },
    {
      event = 'vim_leave',
      handler = function()
        local renderer = require 'neo-tree.ui.renderer'
        local data = read_expanded_state()
        for _, state in ipairs(require('neo-tree.sources.manager')._get_all_states()) do
          if state.name == 'filesystem' and state.path and state.tree then data[state.path] = renderer.get_expanded_nodes(state.tree) end
        end
        pcall(vim.fn.writefile, { vim.json.encode(data) }, expanded_state_file)
      end,
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
