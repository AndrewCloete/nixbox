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

-- Markdown specific autocommand for wrapping
vim.api.nvim_create_autocmd("FileType", {
	pattern = "text,markdown,tex",
	-- command = "setlocal textwidth=80", Auto break at line 80 for markdown files
	command = "set wrap linebreak textwidth=0 wrapmargin=0",
})

-- Forces java files to preferred tab settings
-- Does not work since JDTLS loads AFTER the file is loaded
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "java",
-- 	callback = function()
-- 		vim.bo.tabstop = 4
-- 		vim.bo.shiftwidth = 4
-- 		vim.bo.expandtab = true
-- 	end,
-- })

-- Handle diff mode specific highlights
if vim.api.nvim_win_get_option(0, "diff") then
	-- Better colors
	-- Is there a more elegant way to set these rather than calling the nvim_command? Can't these be set using options?
	vim.api.nvim_command("hi DiffAdd         ctermfg=232 ctermbg=LightGreen guifg=#003300 guibg=#DDFFDD gui=none cterm=none")
	vim.api.nvim_command("hi DiffChange ctermbg=white  guibg=#ececec gui=none     cterm=none")
	vim.api.nvim_command("hi DiffText    ctermfg=233  ctermbg=yellow  guifg=#000033 guibg=#DDDDFF gui=none cterm=none")
end