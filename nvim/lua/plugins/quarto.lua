return {
  'quarto-dev/quarto-nvim',
  dependencies = {
    'jmbuhr/otter.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  ft = { 'quarto', 'markdown', '.ipynb' },
  opts = {
    debug = false,
    closePreviewOnExit = true,
    lspFeatures = {
      enabled = true,
      chunks = 'all',
      languages = { 'r', 'python', 'julia', 'bash', 'html' },
      diagnostics = {
        enabled = true,
        triggers = { 'BufWritePost' },
      },
      completion = {
        enabled = true,
      },
    },
    codeRunner = {
      enabled = false,
      default_method = 'molten', -- 'molten' or 'slime'
      never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
    },
  },
}
