return {
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function(_, opts)
            if opts.ensure_installed ~= "all" then
                opts.ensure_installed = require("astrocore").list_insert_unique(
                    opts.ensure_installed,
                    { "swift" }
                )
            end
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed = require("astrocore").list_insert_unique(
                opts.ensure_installed,
                { "codelldb" }
            )
        end,
    },
    {
        "AstroNvim/astrolsp",
        optional = true,
        ---@type AstroLSPOpts
        opts = {
            servers = { "sourcekit" },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            local null_ls = require "null-ls"
            if not opts.sources then opts.sources = {} end
            opts.sources = vim.list_extend(opts.sources, {
                null_ls.builtins.formatting.swiftformat,
            })
        end,
    },
}
