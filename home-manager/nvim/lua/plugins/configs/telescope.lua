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
	pickers = {
		live_grep = {
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
	},
	extensions = {
		"fzf",
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
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, {
	desc = "[S]earch by [G]rep",
})
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