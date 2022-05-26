local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    max_jobs = 2,
})

-- Install your plugins here
return packer.startup(function(use)
    use("wbthomason/packer.nvim") -- Have packer manage itself
    use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
    use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
    use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
    use("numToStr/Comment.nvim")
    use({
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons", -- optional, for file icon
        },
    })
    use("moll/vim-bbye")
    use("nvim-lualine/lualine.nvim")
    use("akinsho/toggleterm.nvim")
    use("ahmedkhalf/project.nvim")
    use("lukas-reineke/indent-blankline.nvim")
    use("goolord/alpha-nvim")
    use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
    use("folke/which-key.nvim")
    use("unblevable/quick-scope")
    use("phaazon/hop.nvim")
    use("andymass/vim-matchup")
    use("nacro90/numb.nvim")
    use("norcalli/nvim-colorizer.lua")
    use("windwp/nvim-spectre")
    use("folke/zen-mode.nvim")
    use("karb94/neoscroll.nvim")
    use("folke/todo-comments.nvim")
    use("kevinhwang91/nvim-bqf")
    use("ThePrimeagen/harpoon")
    use("MattesGroeger/vim-bookmarks")
    use("Mephistophiles/surround.nvim")
    use("rcarriga/nvim-notify")
    use("tversteeg/registers.nvim")
    use("nyngwang/NeoZoom.lua")
    use("https://gitlab.com/dbeniamine/vim-mail")

    -- Colorschemes
    use("folke/tokyonight.nvim")
    use("rebelot/kanagawa.nvim")
    use("lunarvim/colorschemes") -- A bunch of colorschemes you can try out
    use("lunarvim/darkplus.nvim")
    use("rose-pine/neovim")

    -- cmp plugins
    use("hrsh7th/nvim-cmp") -- The completion plugin
    use("hrsh7th/cmp-buffer") -- buffer completions
    use("hrsh7th/cmp-path") -- path completions
    use("hrsh7th/cmp-cmdline") -- cmdline completions
    use("saadparwaiz1/cmp_luasnip") -- snippet completions
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-emoji")
    use("hrsh7th/cmp-nvim-lua")

    -- snippets
    use("L3MON4D3/LuaSnip") --snippet engine
    use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

    -- LSP
    use("neovim/nvim-lspconfig") -- enable LSP
    use("williamboman/nvim-lsp-installer") -- simple to use language server installer
    use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
    use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
    use("filipdutescu/renamer.nvim")
    use("simrat39/symbols-outline.nvim")
    use("ray-x/lsp_signature.nvim")
    use("b0o/SchemaStore.nvim")
    use({
        "folke/trouble.nvim",
        cmd = "TroubleToggle",
    })
    use("RRethy/vim-illuminate")

    -- Telescope
    use("nvim-telescope/telescope.nvim")
    use("tom-anders/telescope-vim-bookmarks.nvim")
    use("nvim-telescope/telescope-media-files.nvim")
    use("nvim-telescope/telescope-ui-select.nvim")
    use("nvim-telescope/telescope-file-browser.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use("p00f/nvim-ts-rainbow")
    use("nvim-treesitter/playground")
    use("windwp/nvim-ts-autotag")
    use("lewis6991/nvim-treesitter-context")

    -- Git
    use("lewis6991/gitsigns.nvim")

    -- DAP
    use("mfussenegger/nvim-dap")
    use("theHamsta/nvim-dap-virtual-text")
    use("rcarriga/nvim-dap-ui")
    use("Pocco81/DAPInstall.nvim")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
