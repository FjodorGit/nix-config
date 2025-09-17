return {
  {
    'NeogitOrg/neogit',
    dependecies = {
      'nvim-lua/plenary.vim',
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim', -- optional
    },
    config = true,
    opts = {
      integration = {
        telescope = true,
        diffview = true,
      },
      process_spinner = true,
      mappings = {
        finder = {
          ['<c-j>'] = 'Next',
          ['<c-k>'] = 'Previous',
        },
      },
    },
    event = 'VeryLazy',
    lazy = true,
  },
  {
    'sindrets/diffview.nvim', -- optional
    lazy = true,
    cmd = { 'DiffviewOpen' },
  },
}
