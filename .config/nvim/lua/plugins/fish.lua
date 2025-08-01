return {
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function(_, opts)
            if opts.ensure_installed ~= "all" then
                opts.ensure_installed = require("astrocore").list_insert_unique(
                    opts.ensure_installed,
                    { "fish" }
                )
            end
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            local nls = require "null-ls"
            if not opts.sources then opts.sources = {} end
            opts.sources = vim.list_extend(opts.sources, {
                nls.builtins.formatting.fish_indent,
                nls.builtins.diagnostics.fish,
            })
        end,
    },
}
