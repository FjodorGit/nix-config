return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'stevearc/overseer.nvim', -- for preLaunchTasks
    },
    config = function()
      local dap = require 'dap'
      dap.adapters.codelldb = {
        type = 'executable',
        command = 'codelldb', -- or if not in $PATH: "/absolute/path/to/codelldb"}
      }
      require('dap').adapters.codelldb = {
        type = 'server',
        port = '1337',
        executable = {
          command = vim.env.CODELLDB_BIN,
          args = { '--port', '1337', '--liblldb', vim.env.CODELLDB_LIB },
        },
      }
      -- dap.configurations.cpp = {
      --   {
      --     name = 'Launch file',
      --     type = 'codelldb',
      --     request = 'launch',
      --     program = '${file}',
      --     cwd = '${workspaceFolder}',
      --     stopOnEntry = false,
      --   },
      -- }
      local ui = require 'dapui'
    end,
  },
}
