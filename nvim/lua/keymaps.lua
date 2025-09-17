vim.keymap.set('n', '[f', '<cmd>b#<CR>', { desc = 'Previous Buffer' })

-- always open cmdwindow - optimized
vim.keymap.set('n', ':', function()
  vim.cmd 'silent call feedkeys("q:i", "n")'
end, { silent = true })

-- Delete whole buffer
vim.keymap.set('n', 'dB', 'ggVGd', { desc = 'Clear whole buffer' })

-- Exit insert mode on german keyboard.
vim.keymap.set('i', '<C-ü>', '<Esc>', { desc = 'Exit insert mode' })

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', require('telescope.builtin').oldfiles, { desc = '[/] Find recently opened files' })
vim.keymap.set('n', '<leader>sz', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[S]earch Fu[z]zily current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sG', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sW', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sg', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').resume, { desc = '[S]earch [P]revious' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').registers, { desc = '[S]earch [R]egisters' })

vim.keymap.set('n', 'ma', 'mA', { desc = 'set global mark A' })
vim.keymap.set('n', "'a", "'A", { desc = 'goto global mark A' })
vim.keymap.set('n', 'ms', 'mS', { desc = 'set global mark S' })
vim.keymap.set('n', "'s", "'S", { desc = 'goto global mark S' })
vim.keymap.set('n', 'md', 'mD', { desc = 'set global mark D' })
vim.keymap.set('n', "'d", "'D", { desc = 'goto global mark D' })
vim.keymap.set('n', 'mf', 'mF', { desc = 'set global mark F' })
vim.keymap.set('n', "'f", "'F", { desc = 'goto global mark F' })
vim.keymap.set('n', 'mc', 'mC', { desc = 'set global mark C' })
vim.keymap.set('n', "'c", "'C", { desc = 'goto global mark C' })

-- Git
vim.keymap.set('n', '<leader>gg', function()
  require('neogit').open()
end, { desc = '[G]it Toggle' })

vim.keymap.set('n', '<leader>gc', function()
  require('neogit').open { 'commit' }
end, { desc = '[G]it [C]ommit' })

-- Load Obsidian keymaps in notes/Obsidian folder
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile', 'BufEnter' }, {
  pattern = '/home/fjk/Documents/notes/**.md',
  callback = function(_)
    vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<CR>', { desc = '[O]bsidian [N]ew File' })
    vim.keymap.set('n', '<leader>ob', '<cmd>ObsidianBacklinks<CR>', { desc = '[O]bsidian [B]acklinks' })
    vim.keymap.set('n', 'gd', '<cmd>ObsidianFollowLink<CR>', { desc = '[G]oto [O]bsidian Note' })
  end,
})

-- Molten
vim.keymap.set('n', 'go', ':noautocmd MoltenEnterOutput<CR>', { desc = '[G]oto [O]utput window', silent = true })

-- Quarto
-- local runner = require 'quarto.runner'
-- vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
-- vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
-- vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
-- vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
-- vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })

-- User Commands
vim.keymap.set('n', '<leader>cp', '<cmd>InsertPrintStatementNormal<CR>', { desc = '[C]ode [P]rint variable' })

local function get_visual_selection()
  -- Save the current register content
  local saved_reg = vim.fn.getreg 'v'
  local saved_regtype = vim.fn.getregtype 'v'

  -- Yank the visual selection into register 'v'
  vim.cmd 'normal! "vy'

  -- Get the yanked text
  local selected_text = vim.fn.getreg 'v'

  -- Restore the original register content
  vim.fn.setreg('v', saved_reg, saved_regtype)

  return selected_text
end
vim.keymap.set('v', '<leader>cp', function()
  InsertPrintStatement(get_visual_selection())
end, { desc = '[C]ode [P]rint variable' })

-- document existing key chains
require('which-key').add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d', group = '[D]ebug' },
  { '<leader>d_', hidden = true },
  { '<leader>f', group = '[F]iles' },
  { '<leader>f_', hidden = true },
  { '<leader>g', group = '[G]it' },
  { '<leader>g_', hidden = true },
  { '<leader>h', group = '[H]arpoon' },
  { '<leader>h_', hidden = true },
  { '<leader>l', group = '[L]sp' },
  { '<leader>l_', hidden = true },
  { '<leader>o', group = '[O]bsidian' },
  { '<leader>o_', hidden = true },
  { '<leader>q', group = '[Q]uit' },
  { '<leader>q_', hidden = true },
  { '<leader>s', group = '[S]earch' },
  { '<leader>s_', hidden = true },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>t_', hidden = true },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>w_', hidden = true },
}

-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').add {
  { '<leader>', group = 'VISUAL <leader>', mode = 'v' },
  { '<leader>g', desc = '[G]it', mode = 'v' },
}
