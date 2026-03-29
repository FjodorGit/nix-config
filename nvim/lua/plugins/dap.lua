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
    keys = {
      { '<leader>ds', function() require('dap').continue() end, desc = '[D]ebug [S]tart' },
      { '<leader>dd', function() require('dap').terminate() end, desc = '[D]ebug [D]one' },
      { '<leader>dr', function()
        local dap = require('dap')
        dap.clear_breakpoints()
        dap.toggle_breakpoint()
        dap.continue()
      end, desc = '[D]ebug [R]un To Cursor' },
      { '<leader>dC', function() require('dap').clear_breakpoints() end, desc = '[D]ebug [C]lear Breakpoints' },
      { '<C-b>', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
    },
    config = function()
      local dap = require 'dap'
      local debug_key_maps_set = false

      local function set_debug_keymaps()
        if debug_key_maps_set then
          return
        end
        vim.keymap.set('n', '<C-r>', dap.restart, { desc = '[D]ebug [R]restart', silent = true })
        vim.keymap.set('n', 'o', dap.step_over, { desc = '[D]ebug Step [O]ver', silent = true })
        vim.keymap.set('n', 'O', dap.step_out, { desc = '[D]ebug Step [O]ut', silent = true })
        vim.keymap.set('n', 'c', dap.continue, { desc = '[D]ebug Step [C]ontinue', silent = true })
        vim.keymap.set('n', 'i', dap.step_into, { desc = '[D]ebug Step [I]nto', silent = true })
        vim.keymap.set('n', 'r', dap.run_to_cursor, { desc = '[D]ebug [R]un To Cursor', silent = true })
        vim.keymap.set('n', 'D', dap.terminate, { desc = '[D]ebug Terminate', silent = true })
        vim.keymap.set('n', 'A', require('dap.ui.widgets').hover, { desc = 'Hover', silent = true })

        vim.keymap.set('n', 'R', function()
          require('dap-view').jump_to_view 'repl'
        end, { desc = '[R]epl', silent = true })

        vim.keymap.set({ 'n', 'v' }, 'x', require('dap-view').add_expr, { desc = 'Add [X]pression', silent = true })
        vim.keymap.set('n', '<leader>v', require('dap-view').toggle, { desc = 'Toggle Debug [V]iew', silent = true })
        debug_key_maps_set = true
      end

      local function unset_debug_keymaps()
        if not debug_key_maps_set then
          return
        end

        local keys = { '<C-r>', 'o', 'O', 'c', 'i', 'r', 'D', 'A', 'R', 'x', '<leader>v' }
        for _, key in ipairs(keys) do
          vim.api.nvim_del_keymap('n', key)
        end
        debug_key_maps_set = false
      end

      dap.listeners.before['event_initialized']['dap-keys'] = function(session, body)
        print 'Initialized'
        set_debug_keymaps()
      end

      dap.listeners.before['event_terminated']['dap-keys'] = function(session, body)
        unset_debug_keymaps()
        require('dap-view').close()
      end

      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or '127.0.0.1'
          cb {
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          }
        else
          cb {
            type = 'executable',
            command = '.venv/bin/python',
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          }
        end
      end

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          justMyCode = false,
          program = '${file}',
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.env.CODELLDB_PATH,
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.rust = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          sourceLanguages = { 'rust' },
        },
      }
    end,
  },
  {
    'igorlfs/nvim-dap-view',
    opts = {
      winbar = {
        sections = { 'watches', 'breakpoints', 'threads', 'repl' },
      },
      windows = {
        terminal = {
          hide = { 'python' },
        },
      },
    },
    lazy = true,
  },
}
