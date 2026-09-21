-- Minimal nvim for the terminal helpers. No external plugin manager, and few
-- plugins: it starts on every command-line edit. Mode comes from the caller
-- via TERM_NVIM_MODE.
vim.opt.laststatus = 0
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.swapfile = false

vim.cmd.colorscheme("catppuccin-mocha")

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

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.o.clipboard = "unnamedplus"
vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}

vim.keymap.set("n", "q", "<cmd>q!<CR>")

local mode = vim.env.TERM_NVIM_MODE

if mode == "cmdline" then
	-- Accept: write the buffer back and mark it so zsh runs it. Quitting with
	-- q writes nothing, which leaves the command line untouched.
	vim.keymap.set("n", "<CR>", function()
		local marker = vim.env.TERM_NVIM_ACCEPT
		if marker then
			vim.fn.writefile({}, marker)
		end
		vim.cmd("wq")
	end)
else
	-- Scrollback: read-only, opened at the newest line. The search variant
	-- opens the prompt from here, after the cursor has moved.
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.bo.modifiable = false
			vim.api.nvim_win_set_cursor(0, { math.max(1, vim.fn.prevnonblank(vim.fn.line("$"))), 0 })
			if mode == "scrollback-search" then
				vim.fn.feedkeys("?", "n")
			end
		end,
	})
end

-- Last: a failed install must not cost us the keymaps above.
vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" })
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")
