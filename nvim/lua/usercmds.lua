-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

--List all available lua snippets
local list_snips = function()
  local ft_list = require('luasnip').available()[vim.o.filetype]
  local ft_snips = {}
  for _, item in pairs(ft_list) do
    ft_snips[item.trigger] = item.name
  end
  print(vim.inspect(ft_snips))
end

vim.api.nvim_create_user_command('SnipList', list_snips, {})

function InsertPrintStatement(word)
  word = word:gsub('[\n\r]', ' ')
  local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()
  local indent = current_line:match '^(%s*)' -- Capture leading whitespace

  local filetype = vim.bo.filetype
  local print_statement
  if filetype == 'rust' then
    print_statement = string.format('println!("%s: {:#?}", %s);', word, word)
  elseif filetype == 'cpp' then
    print_statement = string.format('std::cout << "%s:" << %s << std::endl;', word, word)
  elseif filetype == 'python' or filetype == 'lua' then
    print_statement = string.format('print("%s: ", %s)', word, word)
  elseif filetype == 'typescriptreact' or filetype == 'typescript' then
    print_statement = string.format('console.log("%s: ", %s)', word, word)
  else
    return
  end

  vim.api.nvim_buf_set_lines(0, cursor_row, cursor_row, false, { indent .. print_statement })
end

vim.api.nvim_create_user_command('InsertPrintStatementNormal', function()
  InsertPrintStatement(vim.fn.expand '<cword>')
end, {})

local function print_current_file_path()
  local filepath = vim.api.nvim_buf_get_name(0)
  print(filepath)
end

vim.api.nvim_create_user_command('FilePath', print_current_file_path, {})
