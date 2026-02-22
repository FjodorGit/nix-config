vim.opt.laststatus = 0
vim.opt.ruler = false
vim.opt.showmode = false

vim.keymap.set("n", "q", "<cmd>q!<CR>")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

local pipe_data = vim.env.KITTY_PIPE_DATA

local _, cursor_x, _, _, _ = pipe_data:match("(%d+):(%d+),(%d+):(%d+),(%d+)")
cursor_x = tonumber(cursor_x)

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local last_line = vim.fn.prevnonblank(vim.fn.line("$"))
		vim.api.nvim_win_set_cursor(0, { last_line, cursor_x })

		vim.keymap.set("n", "A", function()
			vim.api.nvim_win_set_cursor(0, { last_line, vim.fn.col({ last_line, "$" }) - 1 })
			vim.cmd("startinsert!")
		end)

		vim.keymap.set({ "n", "i" }, "<CR>", function()
			local kitty_listen = vim.env.KITTY_LISTEN_ON
			local window_id = vim.env.KITTY_SOURCE_WID

			local line_text = vim.fn.getline(last_line)
			line_text = vim.fn.strcharpart(line_text, 2)

			if kitty_listen then
				vim.fn.system({
					"kitty",
					"@",
					"--to",
					vim.env.KITTY_LISTEN_ON,
					"send-text",
					"--match",
					"id:" .. window_id,
					"--bracketed-paste=enable",
					"--",
					line_text,
				})
				-- Send Enter as a separate keystroke outside of bracketed paste
				vim.fn.system({
					"kitty",
					"@",
					"--to",
					vim.env.KITTY_LISTEN_ON,
					"send-text",
					"--match",
					"id:" .. window_id,
					"--",
					"\n",
				})
				vim.cmd("q!")
			end
		end)
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		-- Theme inspired by Atom
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	{
		"https://codeberg.org/andyg/leap.nvim",
		lazy = false,
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
			vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")
		end,
	},
})
