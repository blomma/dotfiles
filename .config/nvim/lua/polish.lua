-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Diagram labels for the keycodes in the Elora fourth keymaps that qmk.nvim
-- doesn't know. It replaces substrings, longest key first, so composite
-- keycodes are listed whole to keep their inner keycode from being replaced
-- on its own.
local key_labels = {
    -- Swedish letters and symbols from keymap_swedish.h
    SE_ARNG = "å",
    SE_ODIA = "ö",
    SE_ADIA = "ä",
    SE_PLUS = "+",
    SE_MINS = "-",
    SE_QUOT = "'",
    SE_ACUT = "´",
    SE_TILD = "~",
    SE_CIRC = "^",
    SE_LABK = "<",
    SE_LPRN = "(",
    SE_RPRN = ")",
    SE_LBRC = "[",
    SE_RBRC = "]",

    -- Cross platform symbols from the fourth/cross_platform module
    XP_LCBR = "{",
    XP_RCBR = "}",
    XP_BSLS = "\\",
    XP_PIPE = "|",
    XP_MODE = "mac/win",

    -- Tap dances from the fourth/layout module, tap and double tap
    ["TD(TD_LCBR_RCBR)"] = "{ }",
    ["TD(TD_LPR_RPR)"] = "( )",
    ["TD(TD_LBRC_RBRC)"] = "[ ]",
    ["TD(TD_COMMA_LESS)"] = ", <",
    ["TD(TD_DOT_GRTR)"] = ". >",

    -- Home row mods, tap and hold
    ["LGUI_T(KC_A)"] = "a/lgui",
    ["LALT_T(KC_S)"] = "s/lalt",
    ["LCTL_T(KC_D)"] = "d/lctl",
    ["LSFT_T(KC_F)"] = "f/lsft",
    ["RGUI_T(KC_J)"] = "j/rgui",
    ["RALT_T(KC_K)"] = "k/ralt",
    ["RCTL_T(KC_L)"] = "l/rctl",
    ["RSFT_T(SE_ODIA)"] = "ö/rsft",

    -- Layer keys
    ["MO(NAV)"] = "nav",
    ["LT(NAV, SE_ADIA)"] = "ä/nav",
    ["LT(SYM, KC_SPACE)"] = "spc/sym",
    ["TG(GAME)"] = "tg game",
    ["TG(SETTING)"] = "tg set",

    -- Keycodes qmk.nvim lacks, KC_PAGE_UP would otherwise become pAGE_UP
    KC_PAGE_UP = "pgup",
    QK_BOOT = "boot",
    QK_RGB_MATRIX_MODE_PREVIOUS = "rgb mod-",
    QK_RGB_MATRIX_MODE_NEXT = "rgb mod+",
    QK_RGB_MATRIX_VALUE_DOWN = "rgb val-",
    QK_RGB_MATRIX_VALUE_UP = "rgb val+",
    QK_RGB_MATRIX_SPEED_DOWN = "rgb spd-",
    QK_RGB_MATRIX_SPEED_UP = "rgb spd+",
}

local boards = {
    {
        pattern = "*elora/keymaps/fourth/keymap.c",
        name = "LAYOUT",
        layout = {
            "x x x x x x _ x _ _ x _ x x x x x x",
            "x x x x x x _ x _ _ x _ x x x x x x",
            "x x x x x x _ x _ _ x _ x x x x x x",
            "x x x x x x x x _ _ x x x x x x x x",
            "_ _ _ x x x x x _ _ x x x x x _ _ _",
        },
    },
    {
        pattern = "*halcyon/elora/keymaps/fourth/keymap.c",
        name = "LAYOUT",
        layout = {
            "x x x x x x _ _ _ _ _ x x x x x x",
            "x x x x x x _ _ _ _ _ x x x x x x",
            "x x x x x x _ _ _ _ _ x x x x x x",
            "x x x x x x x x _ x x x x x x x x",
            "_ _ _ x x x x x _ x x x x x _ _ _",
        },
    },
}

local group = vim.api.nvim_create_augroup("MyQMK", {})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePre" }, {
    desc = "Configure and format the QMK board for this buffer",
    group = group,
    pattern = "*keymap.c",
    callback = function(args)
        -- Prefer the specific Halcyon path over the shared Elora suffix.
        for i = #boards, 1, -1 do
            local board = boards[i]
            if
                vim.fn.match(args.file, vim.fn.glob2regpat(board.pattern)) >= 0
            then
                local qmk = require "qmk"
                qmk.setup {
                    name = board.name,
                    auto_format_pattern = board.pattern,
                    comment_preview = { keymap_overrides = key_labels },
                    layout = board.layout,
                }
                -- qmk.setup creates a save hook using its global board options.
                -- Handle saves here so :wall also selects each buffer's board.
                vim.api.nvim_clear_autocmds {
                    group = "QMK",
                    event = "BufWritePre",
                }
                if args.event == "BufWritePre" then qmk.format(args.buf) end
                return
            end
        end
    end,
})
