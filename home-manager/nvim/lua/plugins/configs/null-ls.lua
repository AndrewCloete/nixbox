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

		-- Python formatter
		null_ls.builtins.formatting.ruff,

		-- Go auto-format and auto-import (install with Mason afterward)
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.goimports_reviser, -- More deterministic imports than goimports
	},
})
