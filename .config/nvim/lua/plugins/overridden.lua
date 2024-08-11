---@type LazySpec
return {
    {
        "AstroNvim/astrocore",
        ---@type AstroCoreOpts
        opts = {
            features = {
                notifications = true,
            },
            options = {
                opt = {
                    wrap = true,
                    cmdheight = 1,
                },
            },
            mappings = {
                n = {
                    L = {
                        function()
                            require("astrocore.buffer").nav(vim.v.count1)
                        end,
                        desc = "Next buffer",
                    },
                    H = {
                        function()
                            require("astrocore.buffer").nav(-vim.v.count1)
                        end,
                        desc = "Previous buffer",
                    },

                    ["<Leader>b"] = { desc = "Buffers" },
                },
            },
        },
    },
    {
        "AstroNvim/astrolsp",
        ---@type AstroLSPOpts
        opts = {
            features = {
                inlay_hints = true, -- enable/disable inlay hints on start
            },
            mappings = {
                n = {
                    gl = {
                        function() vim.diagnostic.open_float() end,
                        desc = "Hover diagnostics",
                    },
                    gd = {
                        function() vim.lsp.buf.references() end,
                        desc = "References",
                    },
                    gdd = {
                        function() vim.lsp.buf.definition() end,
                        desc = "Definition of current symbol",
                    },
                },
            },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            scope = { show_start = false, show_end = false },
        },
    },
}
