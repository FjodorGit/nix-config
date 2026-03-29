-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.api.nvim_set_option('clipboard', 'unnamed')

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  -- Useful status updates for LSP
  { 'j-hui/fidget.nvim', opts = {} },

  -- Faster LuaLS setup for Neovim config/plugin development
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'plugins' },
}, {})

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

require('luasnip.loaders.from_lua').lazy_load { paths = { '~/.config/nvim/LuaSnip/' } }
require('luasnip').config.set_config { -- Setting LuaSnip config

  -- Enable autotriggered snippets
  enable_autosnippets = true,

  -- Use Tab (or some other key if you prefer) to trigger visual selection
  store_selection_keys = '<CR>',
}
local Rule = require 'nvim-autopairs.rule'
local npairs = require 'nvim-autopairs'
local cond = require 'nvim-autopairs.conds'

npairs.add_rule(Rule('$', '$', { 'tex', 'markdown' }):with_move(cond.done()))

vim.filetype.add {
  extension = {
    sage = 'python', -- sets sage file extension to python filetype
  },
}

-- require('neotest').setup {
--   adapters = {
--     require 'neotest-python' {
--       runners = 'pytest',
--     },
--     require 'neotest-rust' {
--       args = { '--all-features' },
--     },
--   },
-- }

require 'lsp'
require 'options'
require 'usercmds'
require 'autocmds'
require 'testing'
-- require('oil').setup()
-- require('overseer').setup()
require 'keymaps'
require 'terminal'
--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
