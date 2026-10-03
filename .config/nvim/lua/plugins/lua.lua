local function selene_configured(path)
    return #vim.fs.find(
        "selene.toml",
        { path = path, upward = true, type = "file" }
    ) > 0
end

local is_aarch64 = vim.loop.os_uname().machine == "aarch64"

return {
    {
        "AstroNvim/astrolsp",
        optional = true,
        opts = {
            -- StyLua is provided by none-ls; avoid additional Lua formatters.
            formatting = { disabled = { "lua_ls" } },
            handlers = { stylua = false },
            config = {
                lua_ls = {
                    settings = {
                        Lua = {
                            format = { enable = false },
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
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            treesitter = { ensure_installed = { "lua", "luap" } },
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        optional = true,
        opts = function(_, opts)
            if not opts.handlers then opts.handlers = {} end

            if not is_aarch64 then
                opts.handlers.selene = function(source_name, methods)
                    local null_ls = require "null-ls"
                    for _, method in ipairs(methods) do
                        null_ls.register(
                            null_ls.builtins[method][source_name].with {
                                runtime_condition = function(params)
                                    return selene_configured(params.bufname)
                                end,
                            }
                        )
                    end
                end
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
