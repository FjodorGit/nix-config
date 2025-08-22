-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`

  opts = {
    defaults = {
      file_ignore_patterns = { 'node_modules', '.git' },
      mappings = {
        i = {
          ['<C-j>'] = 'move_selection_next',
          ['<C-k>'] = 'move_selection_previous',
        },
      },
      pickers = {
        find_files = {
          -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
          find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
      },
    },
  },
}
