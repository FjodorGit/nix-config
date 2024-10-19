return {
  'benlubas/molten-nvim',
  dependencies = {
    '3rd/image.nvim',
  },
  build = ':UpdateRemotePlugins',
  ft = { 'ipynb' },
  init = function()
    -- these are examples, not defaults. Please see the readme
    vim.g.molten_image_provider = 'image.nvim'
    vim.g.molten_auto_open_output = false
    vim.g.molten_output_win_max_height = 20
    -- optional, I like wrapping. works for virt text and the output window
    vim.g.molten_wrap_output = true

    -- Output as virtual text. Allows outputs to always be shown, works with images, but can
    -- be buggy with longer images
    vim.g.molten_virt_text_output = true

    -- this will make it so the output shows up below the \`\`\` cell delimiter
    vim.g.molten_virt_lines_off_by_1 = true

    -- python virtualenvs
    -- vim.g.python3_host_prog = vim.fn.expand '/home/fjk/.cache/pypoetry/virtualenvs/sonjasbachelorarbeit-3CDbAiNQ-py3.10'
  end,
}
