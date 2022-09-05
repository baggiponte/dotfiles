local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufmap = function(mode, shortcut, command)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set(mode, shortcut, command, bufopts)
	end

	-- Mappings - See `:help vim.lsp.*`
	bufmap("n", "K", vim.lsp.buf.hover) -- Display hover information about the symbol
	bufmap("n", "gd", vim.lsp.buf.definition) -- Go to definition
	bufmap("n", "gD", vim.lsp.buf.declaration) -- Go to declaration; lesser used
	bufmap("n", "gi", vim.lsp.buf.implementation) -- List all the implementations
	bufmap("n", "go", vim.lsp.buf.type_definition) -- Jumps to the definition of the type symbol
	bufmap("n", "gr", vim.lsp.buf.references) -- Lists all the references
	bufmap("n", "<c-k>", vim.lsp.buf.signature_help) -- Display a function's signature information
	bufmap("n", "<leader>rn", vim.lsp.buf.rename) -- Rename all references of the symbol under the cursor
	bufmap("n", "<leader>f", vim.lsp.buf.formatting)
	bufmap("n", "<leader>ca", vim.lsp.buf.code_action) -- Selects a code action
end

local lspconfig = require("lspconfig")
local servers = { "pyright", "julials", "dockerls", "r_language_server", "bashls" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({ capabilities = capabilities, on_attach = on_attach })
end

lspconfig["sumneko_lua"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" }, -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
			diagnostics = { globals = { "vim" } }, -- Get the language server to recognize the `vim` global
			workspace = { library = vim.api.nvim_get_runtime_file("", true) }, -- Make the server aware of Neovim runtime files
			telemetry = { enable = false }, -- Do not send telemetry data containing a randomized but unique identifier
		},
	},
})
