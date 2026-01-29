-- [[ Global LSP Configuration ]]
-- This file sets up shared LSP settings, server configs, and enables all language servers

-- Global capabilities with nvim-cmp integration
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Apply shared settings to all LSP servers using the wildcard config
vim.lsp.config('*', {
  capabilities = capabilities,
  root_markers = { '.git' },
})

-- [[ LSP Keybindings ]]
-- These are set up via LspAttach autocmd to apply to all LSP servers
local function on_attach(_, bufnr)
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
  nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
  nmap('<leader>li', vim.lsp.buf.incoming_calls, '[G]oto [I]ncoming calls')
  nmap('<leader>ld', require('telescope.builtin').lsp_type_definitions, '[L]sp [D]efinition')
  nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[L]sp document [S]ymbols')
  nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[L]sp workspace [S]ymbols')
  nmap('<leader>ln', function()
    vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = 1 }
  end, '[L]sp [N]ext Error')
  nmap('<leader>lp', function()
    vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = -1 }
  end, '[L]sp [P]revious Error')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('gK', vim.lsp.buf.type_definition, '[G]oto Type Definition')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    on_attach(nil, args.buf)
  end,
})

-- [[ Language Server Configurations ]]

-- Lua
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.stylua.toml', 'stylua.toml', '.git' },
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
})

-- Rust
vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        targetDir = true,
        features = 'all',
      },
      check = {
        features = 'all',
      },
    },
  },
})

-- Python: basedpyright (type checker)
vim.lsp.config('basedpyright', {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyrightconfig.json', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
})

-- Python: ruff (linter/formatter)
vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
})

-- TypeScript/JavaScript
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  init_options = { hostInfo = 'neovim' },
})

-- CSS
vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})

-- HTML
vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ', 'twig', 'hbs' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
})

-- Tailwind CSS
vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
  root_markers = { 'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts', 'postcss.config.js', '.git' },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
      },
    },
  },
})

-- C/C++
vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', '.git' },
})

-- Zig
vim.lsp.config('zls', {
  cmd = { 'zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'zls.json', 'build.zig', '.git' },
})

-- YAML
vim.lsp.config('yamlls', {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose' },
  root_markers = { '.git' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = { format = { enable = true } },
  },
})

-- LaTeX
vim.lsp.config('texlab', {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.git', '.latexmkrc', 'latexmkrc', '.texlabroot', 'Tectonic.toml' },
  settings = {
    texlab = {
      build = {
        executable = 'latexmk',
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
        onSave = false,
      },
      chktex = {
        onOpenAndSave = false,
        onEdit = false,
      },
    },
  },
})

-- Typst
vim.lsp.config('tinymist', {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  root_markers = { '.git' },
})

-- Julia
vim.lsp.config('julials', {
  cmd = {
    'julia',
    '--startup-file=no',
    '--history-file=no',
    '-e',
    [[
      ls_install_path = joinpath(
          get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),
          "environments", "nvim-lspconfig"
      )
      pushfirst!(LOAD_PATH, ls_install_path)
      using LanguageServer, SymbolServer, StaticLint
      popfirst!(LOAD_PATH)
      depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
      project_path = let
          dirname(something(
              Base.load_path_expand((
                  p = get(ENV, "JULIA_PROJECT", nothing);
                  p === nothing ? nothing : isempty(p) ? nothing : p
              )),
              Base.current_project(),
              get(Base.load_path(), 1, nothing),
              Base.load_path_expand("@v#.#"),
          ))
      end
      @info "Running language server" VERSION pwd() project_path depot_path
      server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
      server.runlinter = true
      run(server)
    ]],
  },
  filetypes = { 'julia' },
  root_markers = { 'Project.toml', 'JuliaProject.toml', '.git' },
})

-- SQL
vim.lsp.config('sqlls', {
  cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
  filetypes = { 'sql', 'mysql' },
  root_markers = { '.sqllsrc.json', '.git' },
})

-- [[ Enable Language Servers ]]
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'rust_analyzer'
vim.lsp.enable 'ruff'
vim.lsp.enable 'basedpyright'
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'cssls'
vim.lsp.enable 'html'
vim.lsp.enable 'tailwindcss'
vim.lsp.enable 'clangd'
vim.lsp.enable 'zls'
vim.lsp.enable 'yamlls'
vim.lsp.enable 'texlab'
vim.lsp.enable 'tinymist'
vim.lsp.enable 'julials'
vim.lsp.enable 'sqlls'
