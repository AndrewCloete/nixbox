-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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

vim.keymap.set("n", "<C-q>", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>cl", "i- [ ] ")
vim.keymap.set("n", "<leader>st", "^wi~<Esc>A~<Esc>^")
vim.keymap.set("n", "<leader>ts", ":s/\\~//g<CR>")

-- Git related keymaps
vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gb", ":G blame<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>ph", ":Gitsigns preview_hunk<CR>", { desc = "[P]review [H]unk" })
vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>")
vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>")

-- Quick spell fix
vim.keymap.set("n", "]z", "]sz=<CR>") -- next spelling fix
vim.keymap.set("n", "[z", "[sz=<CR>") -- previous spelling fix

-- Toggle Undotree
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

-- Copilot replace <TAB> (uncomment if you use Copilot)
-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set("i", "<right>", 'copilot#Accept()', { silent = true, expr = true })

-- For f-person/git-blame
vim.g.gitblame_message_template = "<author> • <date> • <summary>"
vim.g.gitblame_date_format = "%r"

-- Temporary keymap for formatting XML
vim.keymap.set("n", "<leader>x", "<cmd>:%!xmllint --format -<CR>")

-- Format current buffer with LSP (if available) or just save
vim.keymap.set("n", "<leader>F", "<cmd>lua vim.lsp.buf.format()<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>") -- Save only, skip formatting if no LSP attached.