-- Modern buffer line with nvim-bufferline
local function gh(repo) return 'https://github.com/' .. repo end
vim.pack.add { gh 'akinsho/bufferline.nvim' }
require('bufferline').setup {
  options = {
    mode = 'buffers',
    style_preset = 'default',
    themable = true,
    numbers = 'none',
    close_command = 'bdelete! %d',
    right_mouse_command = 'bdelete! %d',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    truncate_names = true,
    tab_size = 18,
    diagnostics = 'nvim_lsp',
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level)
      local icon = level:match 'error' and ' ' or ' '
      return '(' .. icon .. count .. ')'
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'Neo-tree',
        text_align = 'left',
        separator = true,
      },
    },
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = 'slant',
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    hover = {
      enabled = true,
      delay = 200,
      reveal = { 'close' },
    },
    groups = {
      options = {
        -- Hide Claude Code buffers from the buffer list
        right_margin = 0,
      },
      items = {
        {
          name = 'claude',
          highlight = { bg = '#1e1e2e' },
        },
      },
    },
  },
}

-- Hide Claude buffers from buffer list
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*claude*',
  callback = function() vim.bo.buflisted = false end,
})

-- Keymaps for buffer navigation
local map = vim.keymap.set
map('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Close buffer' })
map('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Close other buffers' })
