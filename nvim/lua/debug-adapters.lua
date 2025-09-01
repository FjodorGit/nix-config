local dap = require 'dap'
local dapview = require 'dap-view'
local debug_key_maps_set = false

vim.keymap.set('n', '<leader>ds', dap.continue, { desc = '[D]ebug [S]tart' })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = '[D]ebug [T]erminate' })
vim.keymap.set('n', '<leader>dr', function()
  dap.clear_breakpoints()
  dap.toggle_breakpoint()
  dap.continue()
end, { desc = '[D]ebug [R]un To Cursor' })
vim.keymap.set('n', '<leader>dC', dap.clear_breakpoints, { desc = '[D]ebug [C]lear Breakpoints' })
vim.keymap.set('n', '<C-b>', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })

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

-- Function to unset debug-specific keymaps
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
      command = 'python', -- should be made available by something like venv
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    }
  end
end

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = 'Launch file',

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    justMyCode = false,
    program = '${file}', -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
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
