vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("luasnip.loaders.from_vscode").lazy_load() -- load snippets from rafamadriz/friendly-snippets

local cmp = require("cmp")
local luasnip = require("luasnip")

--[[
    - Open the suggestion box with ctrl+Space
    - Enter, Tab and Shift + Tab are used to confirm and select items
--]]

cmp.setup({
	-- REQUIRED - you must specify a snippet engine
	snippet = {
		expand = function(args)
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- if not using luasnip:
		-- ['<Tab>'] = cmp.mapping.select_next_item(),
		-- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
		-- if using luasnip:
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		-- { name = 'ultisnips' },
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- completion from git if you installed cmp_git
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})
