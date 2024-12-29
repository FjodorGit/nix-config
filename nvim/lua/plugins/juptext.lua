return {
  'GCBallesteros/jupytext.nvim',
  config = true,
  lazy = false,
  opts = {
    custom_language_formatting = {
      python = {
        style = 'markdown',
        extension = 'md',
        force_ft = 'markdown',
      },
    },
  },
}
