-- vim options
-- vim.opt.shell = "/bin/sh"
vim.opt.wrap = true -- display lines as one long line
vim.opt.number = false -- set numbered lines
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 2 spaces for a tabvim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation

vim.g.VimMailDontUseComplete = 1
vim.g.VimMailDoNotFold = 1

-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.use_icons = true

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

-- Change theme settings
lvim.colorscheme = "catppuccin-frappe"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.folder = {
	arrow_closed = "",
	arrow_open = "",
	default = "",
	open = "",
	empty = "",
	empty_open = "",
	symlink = "",
	symlink_open = "",
}

lvim.builtin.gitsigns.active = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
lvim.lsp.on_attach_callback = function(client, bufnr)
	if client.name == "omnisharp" then
		-- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
		local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
		for i, v in ipairs(tokenModifiers) do
			local tmp = string.gsub(v, " ", "_")
			tokenModifiers[i] = string.gsub(tmp, "-_", "")
		end
		local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
		for i, v in ipairs(tokenTypes) do
			local tmp = string.gsub(v, " ", "_")
			tokenTypes[i] = string.gsub(tmp, "-_", "")
		end
	end
end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{
		command = "prettier",
	},
	{
		command = "csharpier",
	},
	{
		command = "stylua",
	},
})

-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     command = "shellcheck",
--     args = { "--severity", "warning" },
--   },
-- }

lvim.plugins = {
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"ellisonleao/gruvbox.nvim",
	},
	{
		"Mofiqul/dracula.nvim",
	},
	{
		"marko-cerovac/material.nvim",
	},
	{
		"rebelot/kanagawa.nvim",
	},
	{
		"EdenEast/nightfox.nvim",
	},
	{
		url = "https://gitlab.com/dbeniamine/vim-mail",
	},
	{
		"khaveesh/vim-fish-syntax",
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
	},
	{
		"folke/twilight.nvim",
	},
	{
		"folke/zen-mode.nvim",
	},
}
