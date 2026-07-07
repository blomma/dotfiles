return {
    "nvim-neorg/neorg",
    version = "^9",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = function(_, opts)
        local astrocore = require "astrocore"
        return astrocore.extend_tbl(opts, {
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.keybinds"] = {}, -- Adds default keybindings
                ["core.journal"] = {}, -- Enables support for the journal module
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/Projects/notes",
                        },
                        default_workspace = "notes",
                    },
                },
            },
        })
    end,
    specs = {
        {
            "AstroNvim/astrocore",
            optional = true,
            ---@type AstroCoreOpts
            opts = {
                treesitter = { ensure_installed = { "norg", "norg_meta" } },
            },
        },
    },
}
