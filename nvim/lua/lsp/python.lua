-- Optional: Only required if you need to update the language server settings
vim.lsp.config('ty', {
  settings = {
    ty = {
      inlayHints = {
        callArgumentNames = true,
      },
      experimental = {
        rename = true,
      },
    },
  },
})

vim.lsp.config('ruff', {
  settings = {
    -- Ruff language server settings go here
  },
})

vim.lsp.config('basedpyright', {
  settings = {},
})

vim.lsp.enable 'ruff'
-- vim.lsp.enable 'ty'
vim.lsp.enable 'basedpyright'
