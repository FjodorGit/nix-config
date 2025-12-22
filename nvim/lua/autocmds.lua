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
exclude_set['q!'] = true

vim.api.nvim_create_autocmd('CmdlineLeave', {
  pattern = { ':', '@' },
  callback = function(_)
    vim.o.laststatus = 2
    local cmdline = vim.fn.getcmdline()
    -- local prev_command = vim.fn.histget(':', -1)
    if exclude_set[cmdline] then
      -- Without this, nothing would happen:
      vim.schedule(function()
        vim.fn.histdel(':', -1) -- must re-execute it yourself
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = { ':', '@' },
  callback = function(_)
    vim.o.laststatus = 0
  end,
})
