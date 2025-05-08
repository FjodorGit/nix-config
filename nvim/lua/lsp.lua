-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lh', vim.diagnostic.open_float, '[L]sp [H]over')
  nmap('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')
  nmap('<leader>la', vim.lsp.buf.code_action, '[L]sp [A]ction')
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>ld', require('telescope.builtin').lsp_type_definitions, '[L]sp [D]efinition')
  nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[L]sp document [S]ymbols')
  nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[L]sp workspace [S]ymbols')
  nmap('<leader>ln', function()
    vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  end, '[L]sp [N]ext Error')
  nmap('<leader>lp', function()
    vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  end, '[L]sp [P]revious Error')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('gK', vim.lsp.buf.type_definition, '[G]oto Type Definition')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- -- mason-lspconfig requires that these setup functions are called in this order
-- -- before setting up the servers.
-- require('mason').setup()
-- require('mason-lspconfig').setup()
--
-- -- Enable the following language servers
-- --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
-- --
-- --  Add any additional override configuration in the following tables. They will be passed to
-- --  the `settings` field of the server config. You must look up that documentation yourself.
-- --
-- --  If you want to override the default filetypes that your language server will attach to you can
-- --  define the property 'filetypes' to the map in question.
local lsp_config = require 'lspconfig'
local servers = {
  clangd = {},
  -- gopls = {},
  basedpyright = {},
  ts_ls = {},
  rust_analyzer = {},
  cssls = { filetypes = { 'css' } },
  tailwindcss = { filetypes = { 'html' } },
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  julials = { julia_env_path = '/home/fjk/.julia/environments/nvim-lspconfig' },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
  sqlls = { filetypes = { 'sql' } },
  zls = {},
  yamlls = {},
  texlab = { filetypes = { 'tex' } },
}
--
-- -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
-- -- Ensure the servers above are installed
-- local mason_lspconfig = require 'mason-lspconfig'
--
-- mason_lspconfig.setup {
--   ensure_installed = vim.tbl_keys(servers),
-- }
--
--
for server_name, config in pairs(servers) do
  lsp_config[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = config,
    filetypes = (config or {}).filetypes,
  }
end
