-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

local swedish_key_labels = {
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
        keymap_overrides = { KC_TR = " " },
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

for _, board in ipairs(boards) do
    vim.api.nvim_create_autocmd("BufEnter", {
        desc = "Format simple keymap",
        group = group,
        pattern = board.pattern,
        callback = function()
            require("qmk").setup {
                name = board.name,
                auto_format_pattern = board.pattern,
                comment_preview = {
                    keymap_overrides = vim.tbl_extend(
                        "force",
                        {},
                        swedish_key_labels,
                        board.keymap_overrides or {}
                    ),
                },
                layout = board.layout,
            }
        end,
    })
end
