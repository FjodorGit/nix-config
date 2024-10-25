local function allExpectTheLast(inputList)
  if #inputList == 0 then
    return {} -- Return an empty list if the input list is empty
  elseif #inputList > 1 then
    table.remove(inputList, #inputList) -- Remove the last element if the list contains more than one element
  end
  return inputList
end
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
    },
    new_notes_location = 'Notes',
  },
  -- {
  --   'oflisback/obsidian-bridge.nvim',
  --   dependencies = { 'nvim-telescope/telescope.nvim' },
  --   config = function()
  --     require('obsidian-bridge').setup()
  --   end,
  --   event = {
  --     -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --     -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --     'BufReadPre /home/fjk/Documents/Obsidian Vault/**.md',
  --     'BufNewFile /home/fjk/Documents/Obsidian Vault/**.md',
  --     'BufEnter /home/fjk/Documents/Obsidian Vault/**.md',
  --   },
  --   lazy = true,
  -- },
}
