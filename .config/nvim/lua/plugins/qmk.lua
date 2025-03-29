return {
    "codethread/qmk.nvim",
    config = function()
        ---@type qmk.UserConfig
        local conf = {
            name = "LAYOUT",
            comment_preview = {
                keymap_overrides = {
                    HERE_BE_A_LONG_KEY = "Magic", -- replace any long key codes
                },
            },
            -- auto_format_pattern = "*fourth/keymap.c",
            layout = {
                "x x x x x x _ x _ _ x _ x x x x x x",
                "x x x x x x _ x _ _ x _ x x x x x x",
                "x x x x x x _ x _ _ x _ x x x x x x",
                "x x x x x x x x _ _ x x x x x x x x",
                "_ _ _ x x x x x _ _ x x x x x _ _ _",
            },
        }
        require("qmk").setup(conf)
    end,
}
