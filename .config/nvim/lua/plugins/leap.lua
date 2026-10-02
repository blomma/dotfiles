return {
    "https://codeberg.org/andyg/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    keys = {
        {
            "s",
            "<Plug>(leap-forward)",
            mode = { "n", "x", "o" },
            desc = "Leap forward",
        },
        {
            "S",
            "<Plug>(leap-backward)",
            mode = { "n", "x", "o" },
            desc = "Leap backward",
        },
        {
            "gs",
            "<Plug>(leap-from-window)",
            mode = { "n", "x", "o" },
            desc = "Leap from window",
        },
    },
    specs = {
        {
            "catppuccin",
            optional = true,
            opts = { integrations = { leap = true } },
        },
    },
    opts = {},
}
