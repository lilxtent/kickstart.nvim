-- render-markdown.nvim: renders markdown (headings, code blocks, escape
-- sequences, etc.) inline -- including inside blink.cmp's hover/completion
-- documentation floating windows, where gopls's escaped doc-comment links
-- (e.g. `\[\*PathError\]`) would otherwise show their backslashes literally.
-- https://github.com/MeanderingProgrammer/render-markdown.nvim

vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
}
