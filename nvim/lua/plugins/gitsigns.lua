return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  lazy = true,
  event = 'BufEnter',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- visual mode
      map('v', '<leader>gs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = '[G]it [S]tage hunk' })
      map('v', '<leader>gr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = '[G]it [R]eset hunk' })
      --
      -- normal mode
      map('n', '<leader>gs', gs.stage_hunk, { desc = '[G]it [S]tage hunk' })
      map('n', '<leader>gr', gs.reset_hunk, { desc = '[G]it [R]eset hunk' })
      map('n', '<leader>gR', gs.reset_buffer, { desc = '[G]it [R]eset buffer' })
      map('n', '<leader>gp', gs.preview_hunk, { desc = '[Git] [P]review hunk' })
      map('n', '<leader>gd', gs.diffthis, { desc = '[G]it [D]iff staged' })
      map('n', '<leader>gD', function()
        gs.diffthis '~'
      end, { desc = '[G]it [D]iff last commit' })

      -- Toggles
      map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = '[G]it [B]lame' })
      map('n', '<leader>cd', gs.toggle_deleted, { desc = '[C]ode show [D]eleted' })
    end,
  },
}
