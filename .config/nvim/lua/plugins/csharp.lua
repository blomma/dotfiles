return {
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function(_, opts)
            if opts.ensure_installed ~= "all" then
                opts.ensure_installed = require("astrocore").list_insert_unique(
                    opts.ensure_installed,
                    { "c_sharp" }
                )
            end
        end,
    },
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        dependencies = {
            {
                "AstroNvim/astrolsp",
                opts = {
                    handlers = {
                        csharp_ls = function(server, opts)
                            require("lspconfig")[server].setup(opts)
                            require("csharpls_extended").buf_read_cmd_bind()
                        end,
                    },
                },
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed =
                require("astrocore").list_insert_unique(opts.ensure_installed, {
                    "csharp-language-server",
                    "csharpier",
                })
        end,
    },
    -- {
    --     "nvim-neotest/neotest",
    --     optional = true,
    --     dependencies = { "Issafalcon/neotest-dotnet", config = function() end },
    --     opts = function(_, opts)
    --         if not opts.adapters then opts.adapters = {} end
    --         table.insert(
    --             opts.adapters,
    --             require "neotest-dotnet"(
    --                 require("astrocore").plugin_opts "neotest-dotnet"
    --             )
    --         )
    --     end,
    -- },
}
