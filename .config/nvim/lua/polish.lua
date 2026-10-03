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
