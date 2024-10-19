return {
  {
    -- Theme inspired by Atom
    'catppuccin/nvim',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
      }
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
}
