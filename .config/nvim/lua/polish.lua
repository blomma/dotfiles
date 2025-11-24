-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
--
local group = vim.api.nvim_create_augroup("MyQMK", {})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format simple keymap",
    group = group,
    pattern = "*elora/keymaps/fourth/keymap.c", -- this is a pattern to match the filepath of whatever board you wish to target
    callback = function()
        require("qmk").setup {
            name = "LAYOUT",
            auto_format_pattern = "*elora/keymaps/fourth/keymap.c",
            comment_preview = {
                keymap_overrides = {
                    SE_LESS = "<",
                    SE_GRTR = ">",
                    SE_AA = "å",
                    SE_OSLH = "ö",
                    SE_ADIA = "ä",
                    SE_PLUS = "+",
                    SE_MINS = "-",
                    SE_APOS = "'",
                    SE_DIAE = "",
                    SE_ACUT = "´",
                    SE_LPRN = "(",
                    SE_RPRN = ")",
                    SE_LBRC = "[",
                    SE_RBRC = "]",
                    SE_CIRC = "^",
                    SE_LCBR = "{",
                    SE_RCBR = "}",
                    SE_LCBR_MAC = "{",
                    SE_RCBR_MAC = "}",
                    SE_BSLS = "\\",
                    SE_BSLS_MAC = "\\",
                    SE_TILD = "~",
                },
            },
            layout = {
                "x x x x x x _ x _ _ x _ x x x x x x",
                "x x x x x x _ x _ _ x _ x x x x x x",
                "x x x x x x _ x _ _ x _ x x x x x x",
                "x x x x x x x x _ _ x x x x x x x x",
                "_ _ _ x x x x x _ _ x x x x x _ _ _",
            },
        }
    end,
})
vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format simple keymap",
    group = group,
    pattern = "*halcyon/elora/keymaps/fourth/keymap.c", -- this is a pattern to match the filepath of whatever board you wish to target
    callback = function()
        require("qmk").setup {
            name = "LAYOUT_elora_hlc",
            auto_format_pattern = "*halcyon/elora/keymaps/fourth/keymap.c",
            comment_preview = {
                keymap_overrides = {
                    SE_LESS = "<",
                    SE_GRTR = ">",
                    SE_AA = "å",
                    SE_OSLH = "ö",
                    SE_ADIA = "ä",
                    SE_PLUS = "+",
                    SE_MINS = "-",
                    SE_APOS = "'",
                    SE_DIAE = "",
                    SE_ACUT = "´",
                    SE_LPRN = "(",
                    SE_RPRN = ")",
                    SE_LBRC = "[",
                    SE_RBRC = "]",
                    SE_CIRC = "^",
                    SE_LCBR = "{",
                    SE_RCBR = "}",
                    SE_LCBR_MAC = "{",
                    SE_RCBR_MAC = "}",
                    SE_BSLS = "\\",
                    SE_BSLS_MAC = "\\",
                    SE_TILD = "~",
                    KC_TR = " ",
                },
            },
            layout = {
                "x x x x x x _ _ _ _ _ x x x x x x",
                "x x x x x x _ _ _ _ _ x x x x x x",
                "x x x x x x _ _ _ _ _ x x x x x x",
                "x x x x x x x x _ x x x x x x x x",
                "_ _ _ x x x x x _ x x x x x _ _ _",
                "x x x x x _ _ _ _ _ _ _ x x x x x",
            },
        }
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format simple keymap",
    group = group,
    pattern = "*halcyon/kyria/keymaps/fourth/keymap.c", -- this is a pattern to match the filepath of whatever board you wish to target
    callback = function()
        require("qmk").setup {
            name = "LAYOUT_split_3x6_5_hlc",
            auto_format_pattern = "*halcyon/kyria/keymaps/fourth/keymap.c",
            comment_preview = {
                keymap_overrides = {
                    SE_LESS = "<",
                    SE_GRTR = ">",
                    SE_AA = "å",
                    SE_OSLH = "ö",
                    SE_ADIA = "ä",
                    SE_PLUS = "+",
                    SE_MINS = "-",
                    SE_APOS = "'",
                    SE_DIAE = "",
                    SE_ACUT = "´",
                    SE_LPRN = "(",
                    SE_RPRN = ")",
                    SE_LBRC = "[",
                    SE_RBRC = "]",
                    SE_CIRC = "^",
                    SE_LCBR = "{",
                    SE_RCBR = "}",
                    SE_LCBR_MAC = "{",
                    SE_RCBR_MAC = "}",
                    SE_BSLS = "\\",
                    SE_BSLS_MAC = "\\",
                    SE_TILD = "~",
                },
            },
            layout = {
                "x x x x x x _ _ _ _ _ _ x x x x x x",
                "x x x x x x _ _ _ _ _ _ x x x x x x",
                "x x x x x x x x _ _ x x x x x x x x",
                "_ _ _ x x x x x _ _ x x x x x _ _ _",
                "x x x x x _ _ _ _ _ _ _ _ x x x x x",
            },
        }
    end,
})
