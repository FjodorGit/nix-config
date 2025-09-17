-- Format on save/buffer write
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Open help windows in vertical split
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  callback = function()
    vim.cmd 'wincmd L'
  end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  pattern = '@',
  callback = function(_)
    vim.o.laststatus = 2
  end,
})

vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '@',
  callback = function(_)
    vim.o.laststatus = 0
  end,
})

local exclude_set = { w = true, q = true, wq = true, x = true }
vim.api.nvim_create_autocmd('CmdlineLeave', {
  pattern = ':',
  callback = function(_)
    vim.o.laststatus = 2
    local cmdline = vim.fn.getcmdline()
    if exclude_set[cmdline] then
      -- Without this, nothing would happen:
      vim.schedule(function()
        vim.fn.histdel(':', -1) -- must re-execute it yourself
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = ':',
  callback = function(_)
    vim.o.laststatus = 0
    local max_hist = vim.fn.histnr ':' + 1
    local history_index = max_hist -- Start after the current (last) entry

    vim.keymap.set('n', 'k', function()
      history_index = math.max(1, history_index - 1)
      local cmd = vim.fn.histget(':', history_index)
      if cmd ~= '' then
        vim.fn.setline('.', cmd)
      end
    end, { buffer = true, desc = 'Previous command from history' })

    vim.keymap.set('n', 'j', function()
      history_index = math.min(max_hist, history_index + 1)
      if history_index >= max_hist then
        vim.fn.setline('.', '')
      else
        local cmd = vim.fn.histget(':', history_index)
        if cmd ~= '' then
          vim.fn.setline('.', cmd)
        end
      end
    end, { buffer = true, desc = 'Previous command from history' })
  end,
})
