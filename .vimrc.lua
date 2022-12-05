-- Local project-level config for Neovim
-- Based on https://gist.github.com/coffebar/6c09c75d5dafcf1d76cc1079e140939c

local augroup_name = "tmp_local_group"
local augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })
local unbind_table = {}
local function bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outer_opts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
		table.insert(unbind_table, {
			op = op,
			lhs = lhs,
		})
	end
end

-- Setup

vim.notify("Setup keymaps")
local nnoremap = bind("n")
local vnoremap = bind("v")

-- normal mode: runs gulp tasks from scripts
-- requires plugin skywind3000/asyncrun.vim
-- to run in async mode and see output in quickfix window
nnoremap("<leader>ew", ":AsyncRun ./watch.sh<cr>")
nnoremap("<leader>eb", ":AsyncRun ./build.sh<cr>")
-- visual mode: extract selection into new scss file
vnoremap("<leader>er", function()
	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local press = function(keys)
		local mode = "x" -- sync mode
		vim.fn.feedkeys(t(keys), mode)
	end

	press("d")

	local new_file = vim.fn.input("New file name: _")
	if new_file == "" then
		press("u")
		return
	end
	local code_line = '@import "inc/' .. new_file .. '";'

	if not string.match(new_file, "*.scss") then
		new_file = new_file .. ".scss"
	end
	new_file = "scss/inc/_" .. new_file

	press(":edit " .. new_file .. "<CR>")
	press("<ESC>G$p")
	press(":edit scss/styles.scss<CR>")
	press("Go" .. code_line .. "<ESC>:w<CR>")
	press(":edit " .. new_file .. "<CR>")
end)

vim.api.nvim_create_autocmd("DirChangedPre", {
	group = augroup,
	-- Undo all changes
	callback = function()
		vim.api.nvim_del_augroup_by_name(augroup_name)
		-- undo keymaps
		vim.notify("Undo keymaps")
		for _, b in ipairs(unbind_table) do
			vim.keymap.set(b.op, b.lhs, "<nop>", { noremap = true })
		end
	end,
})
