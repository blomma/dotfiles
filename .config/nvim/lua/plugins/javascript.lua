-- JavaScript / TypeScript
-- -----------------------
-- vtsls provides language features, ESLint lints projects that configure it,
-- jsonls covers package.json and friends, and vscode-js-debug drives nvim-dap.
--
-- Formatting: Prettier only (prettierd, which mason-null-ls registers with
-- none-ls once it is installed). Prettier honours the project's `.prettierrc`
-- and `.editorconfig`. The language servers' formatters are disabled so a
-- buffer is never formatted twice.

local inlay_hints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = true },
}

-- SchemaStore schemas that claim every `manifest.json`. The name alone does not
-- say which kind it is (Moddable/Pebble Alloy manifests use it too), so they
-- only report false errors. A file can opt in with a `$schema` key.
local ambiguous_schemas = {
    "Foxx Manifest",
    "Web App Manifest",
    "WebExtensions",
}

---@type LazySpec
return {
    {
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            treesitter = {
                ensure_installed = {
                    "javascript",
                    "jsdoc",
                    "json",
                    "tsx",
                    "typescript",
                },
            },
        },
    },
    {
        "AstroNvim/astrolsp",
        optional = true,
        ---@param opts AstroLSPOpts
        opts = function(_, opts)
            opts.formatting = opts.formatting or {}
            opts.formatting.disabled = require("astrocore").list_insert_unique(
                opts.formatting.disabled,
                { "eslint", "jsonls", "vtsls" }
            )

            opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
                vtsls = {
                    settings = {
                        javascript = {
                            inlayHints = inlay_hints,
                            updateImportsOnFileMove = { enabled = "always" },
                        },
                        typescript = {
                            inlayHints = inlay_hints,
                            updateImportsOnFileMove = { enabled = "always" },
                        },
                        vtsls = { enableMoveToFileCodeAction = true },
                    },
                },
                jsonls = {
                    settings = { json = { validate = { enable = true } } },
                    -- Resolved when the server starts, so the SchemaStore
                    -- catalog is only loaded once a JSON file is opened.
                    before_init = function(_, config)
                        config.settings.json.schemas =
                            require("schemastore").json.schemas {
                                ignore = ambiguous_schemas,
                            }
                    end,
                },
            })
        end,
    },
    { "b0o/schemastore.nvim", lazy = true },
    {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = {
            handlers = {
                -- mason-nvim-dap knows the `js` package but ships no adapter
                -- or configurations for it, so both are defined here.
                js = function()
                    local dap = require "dap"

                    dap.adapters["pwa-node"] = {
                        type = "server",
                        host = "localhost",
                        port = "${port}",
                        executable = {
                            command = "js-debug-adapter",
                            args = { "${port}" },
                        },
                    }
                    -- VS Code's launch.json files say "node".
                    dap.adapters.node = function(callback, config)
                        config.type = "pwa-node"
                        callback(dap.adapters["pwa-node"])
                    end

                    for _, filetype in ipairs {
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                    } do
                        dap.configurations[filetype] = {
                            {
                                type = "pwa-node",
                                request = "launch",
                                name = "Node: launch current file",
                                program = "${file}",
                                cwd = "${workspaceFolder}",
                                skipFiles = { "<node_internals>/**" },
                            },
                            {
                                type = "pwa-node",
                                request = "attach",
                                name = "Node: attach to process",
                                processId = function()
                                    return require("dap.utils").pick_process {
                                        filter = "node",
                                    }
                                end,
                                cwd = "${workspaceFolder}",
                                skipFiles = { "<node_internals>/**" },
                            },
                        }
                    end
                end,
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed =
                require("astrocore").list_insert_unique(opts.ensure_installed, {
                    "vtsls",
                    "eslint-lsp",
                    "json-lsp",
                    "prettierd",
                    "js-debug-adapter",
                })
        end,
    },
}
