local conform = require("conform")

conform.setup({
	-- Set the default formatters
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_fix" }, -- ruff_format for formatting, ruff_fix for autofixable linting
		go = { "gofumpt", "goimports_reviser" }, -- Order matters: gofumpt formats, goimports_reviser sorts imports
		-- For Prettier, you'll generally use it for multiple filetypes.
		-- You can define it per filetype or use a global setting for `prettierd`.
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		less = { "prettierd" },
		scss = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
		-- If you had markdown specific needs from null-ls, you'd handle them here or with other plugins.
		-- For disabling markdown breaking lines, that was often a `prettierd` config or Neovim's `textwidth` option.
		-- If you want Neovim to handle wrapping, ensure `textwidth` is set for markdown in `autocommands.lua`.
		-- The `disabled_filetypes = { "markdown" }` from your null-ls setup implies you might want
		-- Neovim's textwidth to take precedence for markdown. If so, `prettierd` should not format it.
		-- To achieve that, *remove* `markdown = { "prettierd" }` from the list above.
	},
	-- Options for the formatters. These are usually passed as arguments to the formatter.
	-- `conform` automatically looks for Mason-installed binaries.
	formatters = {
		prettierd = {
			-- Prettier generally respects editorconfig and project-level configs (.prettierrc).
			-- If you need to pass specific args, do it here.
			-- args = { "--ignore-unknown" },
		},
		ruff_format = {
			-- args = { "--line-length=88" }, -- Example: set a specific line length if not using pyproject.toml
		},
	},

	-- Enable formatting on save.
	-- You can configure this to run based on specific conditions or disable it for certain filetypes.
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true, -- Try LSP formatting if no conform formatter is found
	},
})

-- Ensure these formatters are installed by Mason
-- You need to add them to your mason-lspconfig.setup block in lsp.lua
-- for automatic installation.
