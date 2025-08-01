-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    dependencies = {
        "astronvim/astrocore",
        opts = {
            diagnostics = {
                -- Disable diagnostics virtual text to prevent duplicates
                virtual_text = false,
            },
        },
    },
    opts = {},
}
