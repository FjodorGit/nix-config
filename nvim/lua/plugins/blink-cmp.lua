return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Use LuaSnip as snippet engine (preserves custom Lua snippets + autosnippets)
    snippets = { preset = 'luasnip' },

    keymap = {
      preset = 'none',
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      [';'] = { 'select_and_accept', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
    },

    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      documentation = { auto_show = true },
      accept = {
        auto_brackets = { enabled = true },
      },
    },

    sources = {
      default = { 'lazydev', 'lsp', 'snippets', 'path', 'buffer' },
      per_filetype = {
        sql = { 'dadbod', 'buffer' },
      },
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    fuzzy = { implementation = 'prefer_rust' },
  },
  opts_extend = { 'sources.default' },
}
