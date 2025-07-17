-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
local ptp = require("utils.plaintextplanner") -- Assuming you move plaintextplanner to utils

luasnip.config.setup({})
local s = luasnip.snippet
local f = luasnip.function_node
luasnip.filetype_extend("javascript", { "javascriptreact" })
luasnip.filetype_extend("javascript", { "html" })

local markdown_snippets = {
	s("d,mon,0", {
		f(function(args, snip)
			return { ptp.getNextWeekday("d,mon,0") }
		end, {}),
	}),
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

for _, combo in ipairs(ptp.generate_combinations()) do
	local function_node = f(function(args, snip)
		return ptp.getNextWeekday(combo)
	end, {})

	table.insert(
		markdown_snippets,
		s(combo, {
			function_node,
		})
	)
end

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
		-- 	if cmp.visible() then
		-- 		cmp.select_next_item()
		-- 	elseif luasnip.expand_or_jumpable() then
		-- 		luasnip.expand_or_jump()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, { 'i', 's' }),
		-- ['<S-Tab>'] = cmp.mapping(function(fallback)
		-- 	if cmp.visible() then
		-- 		cmp.select_prev_item()
		-- 	elseif luasnip.jumpable(-1) then
		-- 		luasnip.jump(-1)
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, { 'i', 's' }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" }, -- very useful for autocompleting commit messages
	}),
})