return {
  'cbochs/grapple.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
  },
  opts = {
    scope = 'git', -- also try out "git_branch"
  },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  keys = {
    { '<leader>m1', '<cmd>Grapple tag index=1<cr>', desc = 'Grapple set tag index 1' },
    { '<leader>m2', '<cmd>Grapple tag index=2<cr>', desc = 'Grapple set tag index 2' },
    { '<leader>m3', '<cmd>Grapple tag index=3<cr>', desc = 'Grapple set tag index 3' },
    { '<leader>m4', '<cmd>Grapple tag index=4<cr>', desc = 'Grapple set tag index 4' },
    { '<leader>1', '<cmd>Grapple select index=1<cr>', desc = 'Grapple select index 1' },
    { '<leader>2', '<cmd>Grapple select index=2<cr>', desc = 'Grapple select index 2' },
    { '<leader>3', '<cmd>Grapple select index=3<cr>', desc = 'Grapple select index 3' },
    { '<leader>4', '<cmd>Grapple select index=4<cr>', desc = 'Grapple select index 4' },
    { '<leader>mq', '<cmd>Grapple quickfix<cr>', desc = 'Grapple quickfix' },
  },
}
