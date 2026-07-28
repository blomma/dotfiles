return {
    {
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            treesitter = { ensure_installed = { "swift" } },
        },
    },
    {
        "AstroNvim/astrolsp",
        optional = true,
        ---@type AstroLSPOpts
        opts = {
            servers = { "sourcekit" },
        },
    },
}
