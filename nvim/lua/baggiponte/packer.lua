vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- [[ Package management ]]
	use("wbthomason/packer.nvim") -- Package manager
	use("lewis6991/impatient.nvim") -- Improve startup time

	-- [[ Colorscheme ]]
	use("sainnhe/gruvbox-material") -- Colorscheme

	-- [[ Dependencies ]]
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("tami5/sqlite.lua")

	-- [[ Git ]]
	use("tpope/vim-fugitive") -- git
	use("lewis6991/gitsigns.nvim") -- git marks to denote added/changed/deleted line
	use("kdheepak/lazygit.nvim") -- Open a floating panel with lazygit

	-- [[ Indentation ]]
	use("tpope/vim-sleuth") -- Auto indentation, hopefully
	use("lukas-reineke/indent-blankline.nvim") -- Highlight indentation

	-- [[ Bracket pairing ]]
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- [[ Comments ]]
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({})
		end,
	})

	-- [[ Statusline ]]
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({ theme = "gruvbox" })
		end,
	})

	-- [[ Telescope ]]

	use({
		"nvim-telescope/telescope.nvim",
		{
			"nvim-telescope/telescope-file-browser.nvim",
			after = "telescope.nvim",
		},
		{
			"nvim-telescope/telescope-frecency.nvim",
			after = "telescope.nvim",
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			after = "telescope.nvim",
			run = "make",
			cond = vim.fn.executable("make") == 1,
		},
	})

	-- [[ Treesitter ]]
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- 'nvim-treesitter/nvim-treesitter-refactor',
		},
		{
			"kylechui/nvim-surround",
			after = "nvim-treesitter",
			config = function()
				require("nvim-surround").setup({})
			end,
		},
		{
			"p00f/nvim-ts-rainbow",
			after = "nvim-treesitter",
		},
	})

	-- [[ LSP ]]
	use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
	-- use 'williamboman/nvim-lsp-installer'                                       -- Automatically install language servers to stdpath
	use({ -- Completion
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			-- 'hrsh7th/cmp-emoji',
			-- "kdheepak/cmp-latex-symbols",
			-- "jc-doyle/cmp-pandoc-references"
		},
		-- -- with cmp-latex-symbols
		-- sources = {
		--   { name = "latex_symbols" },
		-- },
	})

	use("simrat39/symbols-outline.nvim") -- A tree like view for symbols in Neovim using the Language Server Protocol.

	-- [[ Snippets ]]
	use({ "L3MON4D3/LuaSnip", requires = { "saadparwaiz1/cmp_luasnip" } }) -- Snippet Engine and Snippet Expansion
	use("rafamadriz/friendly-snippets") -- Crowdsourced snippets

	-- [[ Other Languages ]]
	use({
		"quarto-dev/quarto-vim",
		requires = {
			{ "vim-pandoc/vim-pandoc-syntax" },
		},
		ft = { "quarto" },
	})
	-- use("quarto-dev/quarto-nvim") -- Quarto support
end)
