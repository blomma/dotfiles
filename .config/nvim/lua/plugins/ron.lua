if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
---@type LazySpec
return {
    {
        "AstroNvim/astrocore",
        ---@type AstroCoreOpts
        opts = {
            filetypes = {
                extension = {
                    ron = "ron",
                },
            },
            treesitter = {
                ensure_installed = {
                    "ron",
                },
            },
        },
    },
    {
        "AstroNvim/astrolsp",
        ---@type AstroLSPOpts
        opts = {
            servers = { "ron_lsp" }, -- always necessary to tell AstroNvim to enable the language server
            config = { -- only necessary if not configured through `lsp/`
                ron_lsp = {
                    cmd = {
                        "ron-lsp",
                    },
                    filetypes = { "ron" },
                    -- root_dir = function(fname)
                    --     local util = require "lspconfig.util"
                    --     return util.root_pattern("Cargo.toml", ".git")(fname)
                    --         or vim.loop.cwd()
                    -- end,
                    settings = {},
                },
            },
        },
    },
}
