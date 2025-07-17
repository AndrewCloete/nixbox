vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.keymaps")
require("plugins.init")
require("utils.autocommands")

vim.opt.conceallevel = 1

-- Final theme load
-- You could also move this into plugins/configs/themes.lua if you only have one theme
-- or if you prefer managing it alongside other theme-related configurations.
require("onedark").setup({
	style = "warmer",
	transparent = true,
	-- style = "light",
})
require("onedark").load()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Set hls color
-- vim.api.nvim_command("hi Search guibg=grey guifg=wheat")
-- vim.api.nvim_command("hi DiffAdd guifg=NONE ctermfg=NONE guibg=#464632 ctermbg=238 gui=NONE cterm=NONE")
-- vim.api.nvim_command("hi DiffChange guifg=NONE ctermfg=NONE guibg=#335261 ctermbg=239 gui=NONE cterm=NONE")
-- vim.api.nvim_command("hi DiffDelete guifg=#f43753 ctermfg=203 guibg=#79313c ctermbg=237 gui=NONE cterm=NONE")