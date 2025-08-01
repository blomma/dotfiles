local is_aarch64 = vim.loop.os_uname().machine == "aarch64"

return {
    {
        "AstroNvim/astrolsp",
        optional = true,
        opts = {
            config = {
                lua_ls = {
                    settings = {
                        Lua = {
                            hint = {
                                enable = true,
                                arrayIndex = "Disable",
                            },
                        },
                    },
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function(_, opts)
            if opts.ensure_installed ~= "all" then
                opts.ensure_installed = require("astrocore").list_insert_unique(
                    opts.ensure_installed,
                    { "lua", "luap" }
                )
            end
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed =
                require("astrocore").list_insert_unique(opts.ensure_installed, {
                    "lua-language-server",
                    "stylua",
                    (not is_aarch64 and "selene") or nil,
                })
        end,
    },
}
