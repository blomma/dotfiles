-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
        -- Configuration table of features provided by AstroLSP
        features = {
            codelens = true, -- enable/disable codelens refresh on start
            inlay_hints = true, -- enable/disable inlay hints on start
            semantic_tokens = true, -- enable/disable semantic token highlighting
        },
        -- customize lsp formatting options
        formatting = {
            -- control auto formatting on save
            format_on_save = {
                enabled = true, -- enable or disable format on save globally
                allow_filetypes = { -- enable format on save for specified filetypes only
                    -- "go",
                },
                ignore_filetypes = { -- disable format on save for specified filetypes
                    "swift",
                },
            },
            disabled = { -- disable formatting capabilities for the listed language servers
            },
            timeout_ms = 1000, -- default format timeout
        },
        -- enable servers that you already have installed without mason
        servers = {
            -- "pyright"
        },
        -- customize language server configuration passed to `vim.lsp.config`
        -- client specific configuration can also go in `lsp/` in your configuration root (see `:h lsp-config`)
        config = {
            rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        files = {
                            exclude = {
                                ".direnv",
                                ".git",
                                "target",
                            },
                        },
                        check = {
                            command = "clippy",
                            extraArgs = {
                                "--no-deps",
                            },
                        },
                    },
                },
            },
        },
        -- customize how language servers are attached
        handlers = {
            -- a function with the key `*` modifies the default handler, functions takes the server name as the parameter
            -- ["*"] = function(server) vim.lsp.enable(server) end

            -- the key is the server that is being setup with `vim.lsp.config`
            rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
        },
    },
}
