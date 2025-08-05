return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
        -- auto_integrations = true,
        integrations = {
            blink_cmp = true,
            mason = true,
            notify = true,
            which_key = true,
            snacks = {
                enabled = true,
                indent_scope_color = "lavender",
            },
        },
    },
}
