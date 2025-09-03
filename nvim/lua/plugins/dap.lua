return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'igorlfs/nvim-dap-view',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'stevearc/overseer.nvim', -- for preLaunchTasks
    },
    lazy = true,
  },
  {
    'igorlfs/nvim-dap-view',
    opts = {
      winbar = {
        sections = { 'watches', 'breakpoints', 'threads', 'repl' },
      },
      windows = {
        terminal = {
          -- Use the actual names for the adapters you want to hide
          hide = { 'python' }, -- `delve` is known to not use the terminal.
        },
      },
    },
    lazy = true,
  },
}
