return {
  'stevearc/conform.nvim',
  lazy = true,
  event = 'BufEnter',
  opts = {
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      nix = { 'nixfmt' },
      -- Use a sub-list to run only the first available formatter
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      rust = { 'rustfmt' },
      julia = { 'JuliaFormatter' },
      sql = { 'pg_format' },
      latex = { 'latexindent' },
      json = { 'jq' },
    },
  },
}
