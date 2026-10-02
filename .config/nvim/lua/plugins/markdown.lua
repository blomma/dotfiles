return {
    {
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            treesitter = {
                ensure_installed = { "markdown", "markdown_inline" },
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed = require("astrocore").list_insert_unique(
                opts.ensure_installed,
                { "marksman" }
            )
        end,
    },
}
