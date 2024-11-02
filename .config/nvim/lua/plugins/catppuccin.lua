---@type LazySpec
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            dim_inactive = { enabled = true, percentage = 0.25 },
            integrations = {
                aerial = true,
                alpha = true,
                cmp = true,
                dap = true,
                dap_ui = true,
                gitsigns = true,
                illuminate = true,
                indent_blankline = true,
                markdown = true,
                mason = true,
                native_lsp = true,
                neotree = true,
                notify = true,
                semantic_tokens = true,
                symbols_outline = true,
                telescope = true,
                treesitter = true,
                ts_rainbow = false,
                ufo = true,
                which_key = true,
                window_picker = true,
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        },
    },
}
