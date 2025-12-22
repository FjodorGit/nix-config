return {
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      'BufReadPre /home/fjk/Documents/notes/**.md',
      'BufNewFile /home/fjk/Documents/notes/**.md',
      'BufEnter /home/fjk/Documents/notes/**.md',
    },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',
    },
    opts = {
      workspaces = {
        {
          name = 'personal',
          path = '~/Documents/notes/',
        },
      },
      disable_frontmatter = false,
      daily_notes = {},
      ui = {
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          ['x'] = { char = '', hl_group = 'ObsidianDone' },
        },
      },
    },
    new_notes_location = 'Notes',
  },
  -- {
  --   'oflisback/obsidian-bridge.nvim',
  --   dependencies = { 'nvim-telescope/telescope.nvim' },
  --   opts = {
  --     obsidian_server_address = 'http://localhost:27123',
  --     scroll_sync = false, -- See "Sync of buffer scrolling" section below
  --     cert_path = nil, -- See "SSL configuration" section below
  --     warnings = true, -- Show misconfiguration warnings. Recommended to keep this on unless you know what you're doing!
  --   },
  --   event = {
  --     -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --     -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --     'BufReadPre /home/fjk/Documents/notes/**.md',
  --     'BufNewFile /home/fjk/Documents/notes/**.md',
  --     'BufEnter /home/fjk/Documents/notes/**.md',
  --   },
  --   lazy = true,
  -- },
}
