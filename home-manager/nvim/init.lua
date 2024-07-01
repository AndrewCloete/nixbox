require("doobie")

--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, and understand
  what your configuration is doing.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
-- NB this superceeds "plug", "packer" etc. Also note how this lua below installs it automatically
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
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration

	--
	"simrat39/rust-tools.nvim",
	"neovim/nvim-lspconfig",
	--
	"tpope/vim-commentary",

	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"f-person/git-blame.nvim",
	"idanarye/vim-merginal",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	-- TODO: Replace vinegar with telescope-file-browser
	"tpope/vim-vinegar", -- no bullshit minimal netrw
	"tpope/vim-tbone", -- tmux integration
	"mbbill/undotree",

	-- 'github/copilot.vim',

	-- This is the easiest way to get prettierd to work
	"jose-elias-alvarez/null-ls.nvim",

	"nvim-tree/nvim-web-devicons",
	-- 'onsails/lspkind-nvim',
	--
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
	--  The configuration is done below. Search for lspconfig to find it below.
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

	{
		-- Theme inspired by Atom
		"navarasu/onedark.nvim",
	},

	-- {
	--   "catppuccin/nvim",
	--   priority = 1000,
	--   config = function()
	--     vim.cmd.colorscheme "catppuccin"
	--   end,
	-- },
	-- {
	--   'folke/tokyonight.nvim',
	--   priority = 1000,
	--   config = function()
	--     vim.cmd.colorscheme "tokyonight"
	--   end,
	-- },
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("kanagawa")
		end,
	},
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
		--       refer to the README for telescope-fzf-native for more instructions.
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

	-- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
	--       These are some example plugins that I've included in the kickstart repository.
	--       Uncomment any of the lines below to enable them.
	-- require 'kickstart.plugins.autoformat',
	-- require 'kickstart.plugins.debug',

	-- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
	--    up-to-date with whatever is in the kickstart repo.
	--
	--    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
	--
	--    An additional note is that if you only copied in the `init.lua`, you can just comment this line
	--    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
	-- { import = "custom.plugins" },
}, {})

require("onedark").setup({
	style = "deep",
})
require("onedark").load()

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
		path_display = { "truncate" },
	},
	extensions = {
		file_browser = {
			respect_gitignore = false,
			git_status = true,
			use_fd = true,
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "[F]ind [o]ld" })

vim.keymap.set("n", "<leader><Tab>", function()
	require("telescope.builtin").buffers({ ignore_current_buffer = true, sort_mru = true })
end, { desc = "[ ] Find existing buffers" })

vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord (grep" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" }) -- issues, errors
vim.keymap.set("n", "<leader>sC", require("telescope.builtin").commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sm", require("telescope.builtin").man_pages, { desc = "[S]earch [m]anpages" })
vim.keymap.set("n", "<leader>sm", require("telescope.builtin").man_pages, { desc = "[S]earch [m]an pages" })
vim.keymap.set("n", "<leader>s'", require("telescope.builtin").marks, { desc = "[S]earch marks" })
vim.keymap.set("n", "<leader>gc", require("telescope.builtin").git_commits, { desc = "[g]it [c]ommits" })

-- Install "fd" for best experience
vim.keymap.set(
	"n",
	"<space>b",
	require("telescope").extensions.file_browser.file_browser,
	{ noremap = true, desc = "[B]rowse" }
)

-- File browser in current directory
vim.api.nvim_set_keymap(
	"n",
	"<space>bf",
	":Telescope file_browser path=%:p:h select_buffer=true<CR>",
	{ noremap = true, desc = "[B]rows [F]older" }
)

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gb", ":G blame<CR>", { desc = "Git blame" })

-- Moving between splits
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>")
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>")
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>")

-- Convenient yank to cliboard
vim.keymap.set("n", "<leader>w", '"+yiw')
vim.keymap.set("n", "<leader>W", '"+yiW')

-- Clear search highlight
vim.keymap.set("n", "<leader>n", "<cmd>noh<cr>")

-- seach visually selected
vim.keymap.set("v", "<leader>*", "y/\\V<C-r>=escape(@\",'/\\')<CR><CR>")

-- Yank to/from tmux cli
vim.keymap.set("v", "ty", ":Tyank<CR>")
vim.keymap.set("n", "tp", ":Tput<CR>")

-- Yank to system clipboard fast
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')

-- Make Y behave like other capitals "to end of line"
vim.keymap.set("n", "Y", "y$")

vim.keymap.set("n", "<leader>ph", ":Gitsigns preview_hunk<CR>", { desc = "[P]review [H]unk" })

vim.keymap.set("n", "<C-q>", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>cl", "i- [ ] ")

-- Dont bind the hunk shortcuts in diff mode. Diff uses these
if vim.api.nvim_win_get_option(0, "diff") then
	-- Better colors
	-- Is there a more elegant way to set these rather than calling the nvim_command? Can't these be set using options?
	vim.api.nvim_command("hi DiffAdd    ctermfg=232 ctermbg=LightGreen guifg=#003300 guibg=#DDFFDD gui=none cterm=none")
	vim.api.nvim_command("hi DiffChange ctermbg=white  guibg=#ececec gui=none   cterm=none")
	vim.api.nvim_command("hi DiffText   ctermfg=233  ctermbg=yellow  guifg=#000033 guibg=#DDDDFF gui=none cterm=none")
end

vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>")
vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>")

-- Quick spell fix
vim.keymap.set("n", "]z", "]sz=<CR>") -- next spelling fix
vim.keymap.set("n", "[z", "[sz=<CR>") -- previous spelling fix

-- Copilot replace <TAB>
-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set("i", "<right>", 'copilot#Accept()', { silent = true, expr = true })

-- For f-person/git-blame
vim.g.gitblame_message_template = "<author> • <date> • <summary>"
vim.g.gitblame_date_format = "%r"

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		"c",
		"cpp",
		"go",
		"lua",
		"python",
		"rust",
		"tsx",
		"typescript",
		"vimdoc",
		"vim",
		"javascript",
		"markdown",
		"markdown_inline",
		"fish",
		"terraform",
		"bash",
		"json",
		"hocon",
	},

	filetype_to_parsername = { xml = "html" },

	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
	auto_install = false,

	highlight = { enable = true },
	indent = { enable = true, disable = { "python" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<M-space>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	-- Pro tip: do the command twice to move focus to the hover window and q to close it
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	-- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
	--   vim.lsp.buf.format()
	-- end, { desc = 'Format current buffer with LSP' })
	-- vim.keymap.set('n', '<leader>f', ":Format<CR>:w<CR>")
	local dont_auto_format = { "jdtls" }
	local lsp_name = client.name
	if not table.concat(dont_auto_format, ","):find(lsp_name, 1, true) then
		vim.keymap.set("n", "<C-s>", "<cmd>lua vim.lsp.buf.format()<CR>:w<CR>")
	else
		print("Not autoformatting '" .. lsp_name .. "'")
	end
end

-- Temp keymap for formatting xml
vim.keymap.set("n", "<leader>x", "<cmd>:%!xmllint --format -<CR>")
vim.keymap.set("n", "<leader>F", "<cmd>lua vim.lsp.buf.format()<CR>")

-- Skip formatting when no LSP is attached and only save
vim.keymap.set("n", "<C-s>", ":w<CR>")

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- pyright = {},
	-- ruff_lsp = {},
	-- tsserver = {},
	-- clangd = {},
	-- gopls = {},

	-- When I installed rnix using Mason, then formatting worked...
	-- lemminx = {},
	-- nil_ls = {}, -- LSP for Nix language
	-- jdtls = {},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	-- tsserver = {},

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

-- rust-tools: Gives the nice inlay hints and code actions
local rt = require("rust-tools")
rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Lesson: you must call this first otherwise the hover_actions are overwritten
			on_attach(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<leader>ca", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
	tools = {
		hover_actions = {
			-- When opening "code actions" move the focus to the code actions window
			auto_focus = true,
		},
	},
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})
local s = luasnip.snippet
local f = luasnip.function_node

local markdown_snippets = {
	s("td", {
		f(function(args, snip)
			return {
				"---------------------------------------------------------------",
				"# " .. os.date("%A, %d %B %Y"),
				"",
			}
		end, {}),
	}),
	s("tom", {
		f(function(args, snip)
			return {
				"---------------------------------------------------------------",
				"# " .. os.date("%A, %d %B %Y", os.time() + 24 * 60 * 60),
				"",
			}
		end, {}),
	}),
	s("cl", {
		f(function(args, snip)
			return { "- [ ] " }
		end, {}),
	}),
	s("due", {
		f(function(args, snip)
			return { "@d" .. os.date("%Y%m%d") }
		end, {}),
	}),
	s("start", {
		f(function(args, snip)
			return { "@s" .. os.date("%Y%m%d") }
		end, {}),
	}),
	s("vis", {
		f(function(args, snip)
			return { "@v" .. os.date("%Y%m%d") }
		end, {}),
	}),
	s("both", {
		f(function(args, snip)
			return { "@b" .. os.date("%Y%m%d") }
		end, {}),
	}),
	s("x", {
		f(function(args, snip)
			return { "#x" }
		end, {}),
	}),
	s("to", {
		f(function(args, snip)
			return { "@todo" }
		end, {}),
	}),
	s("wip", {
		f(function(args, snip)
			return { "@wip" }
		end, {}),
	}),
}

local common_contexts = { "rel", "mail", "proj", "read", "err", "sat", "rnd", "admin" }
for _, ctx in ipairs(common_contexts) do
	table.insert(
		markdown_snippets,
		s(ctx, { f(function(args, snip)
			return { "#x" .. ctx }
		end, {}) })
	)
end

luasnip.add_snippets("markdown", markdown_snippets)

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),

		-- I like using the arrow keys to navigate the completion menu
		["<right>"] = cmp.mapping.confirm({
			-- behavior = cmp.ConfirmBehavior.Replace,
			select = false, -- dont select the first item (for placing an enter)
		}),

		-- ['<Tab>'] = cmp.mapping(function(fallback)
		--     if cmp.visible() then
		--         cmp.select_next_item()
		--     elseif luasnip.expand_or_jumpable() then
		--         luasnip.expand_or_jump()
		--     else
		--         fallback()
		--     end
		-- end, { 'i', 's' }),
		-- ['<S-Tab>'] = cmp.mapping(function(fallback)
		--     if cmp.visible() then
		--         cmp.select_prev_item()
		--     elseif luasnip.jumpable(-1) then
		--         luasnip.jump(-1)
		--     else
		--         fallback()
		--     end
		-- end, { 'i', 's' }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" }, -- very useful for autocompleting commit messages
	}),
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd.with({
			-- Recent versions of neovim uses the lsp to handler "formatexpr", which
			-- is the command that is invoked when you press `gq` in normal mode. This is a
			-- problem for markdown to break lines since the LSP is not aware of the textwidth=80 setting.
			disabled_filetypes = { "markdown" },
		}),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.ruff, -- Python formatter
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
vim.g.markdown_fenced_languages = { "html", "python", "bash", "sh", "json", "rust", "java" }

-- Default netrw to tree view
vim.g.netrw_liststyle = 3

-- Auto break at line 80 for markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "text,markdown,tex",
	command = "setlocal textwidth=80",
})

vim.api.nvim_command("hi TreesitterContextBottom gui=underline guisp=Grey")

-- Set hls color
-- vim.api.nvim_command("hi Search guibg=grey guifg=wheat")
--
-- vim.api.nvim_command("hi DiffAdd guifg=NONE ctermfg=NONE guibg=#464632 ctermbg=238 gui=NONE cterm=NONE")
-- vim.api.nvim_command("hi DiffChange guifg=NONE ctermfg=NONE guibg=#335261 ctermbg=239 gui=NONE cterm=NONE")
-- vim.api.nvim_command("hi DiffDelete guifg=#f43753 ctermfg=203 guibg=#79313c ctermbg=237 gui=NONE cterm=NONE")
-- vim.api.nvim_command("hi DiffText guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=reverse cterm=reverse")
