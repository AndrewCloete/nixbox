-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
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
	--    vim.lsp.buf.format()
	-- end, { desc = 'Format current buffer with LSP' })
	-- vim.keymap.set('n', '<leader>f', ":Format<CR>:w<CR>")
	local dont_auto_format = {}
	-- local dont_auto_format = { "jdtls" }
	local lsp_name = client.name
	if not table.concat(dont_auto_format, ","):find(lsp_name, 1, true) then
		vim.keymap.set("n", "<C-s>", "<cmd>lua vim.lsp.buf.format()<CR>:w<CR>")
	else
		print("Not autoformatting '" .. lsp_name .. "'")
	end
end

-- Diagnostic keymaps (these could also go in core/keymaps.lua if you prefer)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
-- Add any additional override configuration in the following tables. They will be passed to
-- the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- pyright = {
	-- 	settings = {
	-- 		python = {
	-- 			analysis = {
	-- 				autoSearchPaths = true,
	-- 				useLibraryCodeForTypes = true,
	-- 				diagnosticMode = "openFilesOnly",
	-- 			},
	-- 		},
	-- 	},
	-- },
	-- ruff_lsp = {},
	-- tsserver = {},
	-- clangd = {},
	gopls = {},

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
	-- This enables automatic setup of servers for which you don't provide custom setup below.
	-- It uses the default setup from nvim-lspconfig.
	automatic_installation = true, -- Add this line to automatically install servers
	-- New for v2.x. This callback is executed for each server installed by Mason.
	-- It provides a way to apply common settings or a default `on_attach`.
	handlers = {
		-- This is the default handler. It will be called for all servers Mason installs
		-- that don't have a specific handler defined in this table or below this block.
		-- It essentially takes care of the basic `lspconfig.setup` for all your servers.
		function(server_name)
			-- Only apply default setup if it's not a server we're handling explicitly later
			-- in the `for` loop. This avoids double-setup or conflicts.
			local server_opts = servers[server_name] or {}
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = server_opts.settings, -- Pass through settings from your 'servers' table
			})
		end,
	},
})

-- The explicit setup for emmet_ls and rust_analyzer comes AFTER mason_lspconfig.setup()
-- because mason_lspconfig.setup() with a 'handlers' table now covers the automatic setup.
-- You still need to call specific `lspconfig.server_name.setup` for servers with unique configurations.

local lspconfig = require("lspconfig")
lspconfig.emmet_ls.setup({
	-- on_attach = on_attach, -- You might want to call on_attach here if it's specific for emmet, otherwise the default handler covers it.
	capabilities = capabilities,
	filetypes = {
		"css",
		"eruby",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"svelte",
		"pug",
		"typescriptreact",
		"vue",
	},
	init_options = {
		userLanguages = {
			eelixir = "html-eex",
			eruby = "erb",
			rust = "html",
		},
		html = {
			options = {
				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
				["bem.enabled"] = true,
			},
		},
	},
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
		-- Make sure to pass your rust_analyzer specific settings if you had any from the `servers` table
		-- Example:
		settings = servers.rust_analyzer.settings,
	},
	tools = {
		hover_actions = {
			-- When opening "code actions" move the focus to the code actions window
			auto_focus = true,
		},
	},
})