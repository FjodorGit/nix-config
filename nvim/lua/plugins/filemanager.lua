return {
  'rolv-apneseth/tfm.nvim',
  lazy = false,
  opts = {
    file_manager = 'yazi',
    replace_netrw = true,
    enable_cmds = true,
  },
  keys = {
    { '<leader>e', '<cmd>Tfm<CR>', desc = 'Toggle Yazi' },
  },
}
