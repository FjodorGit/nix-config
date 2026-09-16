-- Minimal nvim for the terminal helpers. Plugin-free on purpose: it starts on
-- every command-line edit. Mode comes from the caller via TERM_NVIM_MODE.
vim.opt.laststatus = 0
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.swapfile = false

vim.cmd.colorscheme("catppuccin-mocha")

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

if vim.env.TERM_NVIM_MODE == "cmdline" then
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
	-- Scrollback: read-only, opened at the newest line.
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.bo.modifiable = false
			vim.api.nvim_win_set_cursor(0, { math.max(1, vim.fn.prevnonblank(vim.fn.line("$"))), 0 })
		end,
	})
end
