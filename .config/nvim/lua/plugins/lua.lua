---@type LazySpec
return {
    {
        "AstroNvim/astrolsp",
        optional = true,
        opts = {
            config = {
                lua_ls = {
                    settings = {
                        Lua = {
                            hint = { enable = true, arrayIndex = "Disable" },
                        },
                    },
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "lua", "luap" },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            ensure_installed = { "lua_ls" },
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        optional = true,
        opts = {
            ensure_installed = { "stylua", "selene" },
        },
    },
}
