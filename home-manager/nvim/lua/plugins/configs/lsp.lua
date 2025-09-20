-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
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

	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Add rust-tools keymaps for rust_analyzer
	if client.name == "rust_analyzer" then
		local rt = require("rust-tools")
		-- These bindings are rust-tools specific and override the general ca binding
		nmap("<leader>ca", rt.hover_actions.hover_actions, "Hover Actions")
		nmap("<leader>a", rt.code_action_group.code_action_group, "Code Action Group")
	end

	local dont_auto_format = {}
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

-- Load lspconfig.util for root_pattern
-- local lspconfig = require("lspconfig")
-- local util = lspconfig.util
local util = require("lspconfig.util")

-- *** NEW MASON-LSPCONFIG V2.0.0+ API START ***

-- 1. Configure each language server explicitly using vim.lsp.config()
--    Settings go here, along with on_attach and capabilities.

-- Pyright configuration
vim.lsp.config("pyright", {
	on_attach = on_attach,
	capabilities = capabilities,
	-- Essential: Ensure root_dir is correctly detected for Pyright
	root_dir = util.root_pattern("pyproject.toml", "requirements.txt", ".git", "pyrightconfig.json", "setup.py")(
		vim.fn.getcwd()
	),
	settings = {
		python = {
			analysis = {
				diagnosticMode = "workspace", -- <--- THIS SHOULD FINALLY STICK!
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				-- If auto-detection of pythonPath fails, uncomment and set this to ABSOLUTE path
				-- pythonPath = "/home/youruser/Workspace/se/pino/consultation-app/.venv/bin/python",
			},
		},
		pyright = {
			-- Add any other pyright-specific settings here
			-- typeCheckingMode = "basic",
		},
	},
})

-- Rust Analyzer configuration
vim.lsp.config("rust_analyzer", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

-- Lua LS configuration
vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

-- Other servers (e.g., gopls, ruff_lsp, clangd, tsserver etc.)
-- Configure them similarly. Example for gopls:
vim.lsp.config("gopls", {
	on_attach = on_attach,
	capabilities = capabilities,
	-- Add gopls specific settings here if any
})

-- Ruff LSP (if you want to enable it for linting/formatting)
vim.lsp.config("ruff_lsp", {
	on_attach = on_attach,
	capabilities = capabilities,
	-- You might want to enable formatting capabilities for Ruff if you use it for that
	-- init_options = {
	--     capabilities = {
	--         documentFormatting = true,
	--     },
	-- },
})

-- 2. Setup Mason and Mason-LSPConfig (NO HANDLERS HERE)
--    This part tells Mason which servers to install and
--    tells Mason-LSPConfig to enable auto-registration for installed servers.
require("mason").setup()

require("mason-lspconfig").setup({
	-- The `ensure_installed` list is still used to tell Mason which servers to manage/install.
	-- You can list them explicitly, or use `automatic_enable = true` to enable all.
	ensure_installed = {
		"pyright",
		"rust_analyzer",
		"lua_ls",
		"gopls",
		"ruff", -- Add ruff to ensure it's installed if you're using it
		"emmet_ls",
		-- "black", "isort", "pylint", "flake8" -- If you want these as formatters/linters via Mason
	},
	-- `automatic_enable = true` is an alternative to `ensure_installed` if you want Mason to manage *all* detected servers.
	-- automatic_enable = true,
})

-- *** NEW MASON-LSPCONFIG V2.0.0+ API END ***

-- The explicit setup for emmet_ls and rust_tools remains outside as they are separate plugins
-- that build *on top of* LSP, not just configure it.

-- emmet_ls setup
vim.lsp.config("emmet_ls", {
	on_attach = on_attach, -- You might want to call on_attach here if it's specific for emmet
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
				["bem.enabled"] = true,
			},
		},
	},
})

-- rust-tools: Gives the nice inlay hints and code actions
local rt = require("rust-tools")
rt.setup({
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },
})
