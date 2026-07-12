-- Linting

vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' }, -- Make sure to install `markdownlint` via mason / npm
  go = { 'golangcilint' }, -- Make sure to install `golangci-lint` via mason
}

-- Work around a bug in nvim-lint's bundled golangci-lint definition: it
-- decides whether to lint the buffer's directory or just the single file
-- based on `go env GOMOD`, but that check (like nvim-lint's own invocation)
-- runs with Neovim's global cwd, not the buffer's directory. In a go.work
-- multi-module workspace, if Neovim's cwd is the workspace root (no go.mod
-- of its own), `go env GOMOD` reports `/dev/null` there, so nvim-lint wrongly
-- concludes "standalone file" and lints it in isolation -- making symbols
-- defined in sibling files in the same package show up as "undefined".
-- Always lint the buffer's own directory instead, regardless of cwd.
local golangcilint = lint.linters.golangcilint
if golangcilint and golangcilint.args then golangcilint.args[#golangcilint.args] = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h') end end

-- To allow other plugins to add linters to require('lint').linters_by_ft,
-- instead set linters_by_ft like this:
-- lint.linters_by_ft = lint.linters_by_ft or {}
-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
--
-- However, note that this will enable a set of default linters,
-- which will cause errors unless these tools are available:
-- {
--   clojure = { "clj-kondo" },
--   dockerfile = { "hadolint" },
--   inko = { "inko" },
--   janet = { "janet" },
--   json = { "jsonlint" },
--   markdown = { "vale" },
--   rst = { "vale" },
--   ruby = { "ruby" },
--   terraform = { "tflint" },
--   text = { "vale" }
-- }
--
-- You can disable the default linters by setting their filetypes to nil:
-- lint.linters_by_ft['clojure'] = nil
-- lint.linters_by_ft['dockerfile'] = nil
-- lint.linters_by_ft['inko'] = nil
-- lint.linters_by_ft['janet'] = nil
-- lint.linters_by_ft['json'] = nil
-- lint.linters_by_ft['markdown'] = nil
-- lint.linters_by_ft['rst'] = nil
-- lint.linters_by_ft['ruby'] = nil
-- lint.linters_by_ft['terraform'] = nil
-- lint.linters_by_ft['text'] = nil

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
