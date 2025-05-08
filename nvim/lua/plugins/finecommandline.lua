return {
  'VonHeikemen/fine-cmdline.nvim',
  enabled = false,
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  opts = {
    cmdline = {
      enable_keymaps = true,
      smart_history = true,
      prompt = '❯ ',
    },
  },
}
