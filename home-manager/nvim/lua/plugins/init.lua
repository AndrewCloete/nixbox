-- Install package manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
-- You can configure plugins using the `config` key.
--
-- You can also configure plugins after the setup call,
-- as they will be available in your neovim runtime.
require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration
	"simrat39/rust-tools.nvim",
	"neovim/nvim-lspconfig",
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"tpope/vim-repeat",

	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"f-person/git-blame.nvim",
	"idanarye/vim-merginal",

	-- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"tpope/vim-vinegar", -- no bullshit minimal netrw
	"tpope/vim-tbone", -- tmux integration
	"mbbill/undotree",

	-- 'github/copilot.vim',

	-- This is the easiest way to get prettierd to work
	"jose-elias-alvarez/null-ls.nvim",

	"nvim-tree/nvim-web-devicons",
	-- 'onsails/lspkind-nvim',

	{
		"folke/zen-mode.nvim",
		opts = {
			plugins = {
				tmux = { enabled = false },
				gitsigns = { enabled = false },
			},
		},
	},

	-- NOTE: This is where your plugins related to LSP can be installed.
	-- The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {}, tag = "legacy" },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
	},

	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
		},
	},

	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Theme inspired by Atom
	"navarasu/onedark.nvim",

	-- {
	-- 	"catppuccin/nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme "catppuccin"
	-- 	end,
	-- },
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("tokyonight-day")
	-- 	end,
	-- },
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("kanagawa")
	-- 	end,
	-- },
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				-- theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 3 } }, -- Path 3: full dir path with home tilde
				lualine_x = { "encoding", "fileformjt", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 3 } }, -- Path 3: full dir path with home tilde
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl.config
		opts = {
			indent = { char = "┊" },
		},
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim", tag = "0.1.4", dependencies = { "nvim-lua/plenary.nvim" } },
	"nvim-telescope/telescope-file-browser.nvim",

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you are having trouble with this installation,
		-- 		refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},

	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	},
	"nvim-treesitter/nvim-treesitter-context",

	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
			-- refer to `:h file-pattern` for more examples
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/Workspace/notebook/obsidian_nb/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/Workspace/notebook/obsidian_nb/*.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = {
				{
					name = "notebook",
					path = "~/Workspace/notebook/obsidian_nb",
				},
			},
			disable_frontmatter = true,

			-- see below for full list of options 👇
		},
	},

	-- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	-- You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
	-- up-to-date with whatever is in the kickstart repo.
	--
	-- For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
	--
	-- An additional note is that if you only copied in the `init.lua`, you can just comment this line
	-- to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
	-- { import = "custom.plugins" },
}, {})

-- Load plugin configurations
require("plugins.configs.lsp")
require("plugins.configs.cmp")
require("plugins.configs.null-ls")
require("plugins.configs.telescope")
require("plugins.configs.treesitter")
-- require("plugins.configs.themes") -- If you decide to move theme setup here