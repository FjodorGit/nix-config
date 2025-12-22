require('neotest').setup {
  adapters = {
    require 'neotest-python' {
      dap = { justMyCode = true },
      args = { '--log-level', 'DEBUG' },
      runner = 'pytest',
      python = '.venv/bin/python',
    },
  },
}

vim.keymap.set('n', '<leader>tn', require('neotest').run.run, { desc = '[T]est [N]earest' })
vim.keymap.set('n', '<leader>to', require('neotest').output_panel.toggle, { desc = '[T]est [O]utput' })
vim.keymap.set('n', '<leader>dt', function()
  require('neotest').run.run { strategy = 'dap' }
end, { desc = '[D]ebug [T]est' })
