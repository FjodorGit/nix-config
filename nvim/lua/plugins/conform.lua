return {
  'stevearc/conform.nvim',
  lazy = true,
  event = 'BufEnter',
  opts = {
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      nix = { 'nixfmt' },
      -- Use a sub-list to run only the first available formatter
      javascript = { { 'prettierd', 'prettier' } },
      rust = { 'rustfmt' },
      julia = { 'JuliaFormatter' },
      sql = { 'pg_format' },
      latex = { 'latexindent' },
    },
  },
}
