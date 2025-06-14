-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
--
local group = vim.api.nvim_create_augroup("MyQMK", {})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format simple keymap",
    group = group,
    pattern = "*fourth/keymap.c", -- this is a pattern to match the filepath of whatever board you wish to target
    callback = function()
        require("qmk").setup {
            name = "LAYOUT",
            auto_format_pattern = "*fourth/keymap.c",
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

-- vim.api.nvim_create_autocmd("BufEnter", {
--     desc = "Format overlap keymap",
--     group = group,
--     pattern = "*overlap/keymap.c",
--     callback = function()
--         require("qmk").setup {
--             name = "LAYOUT_preonic_grid",
--             auto_format_pattern = "*overlap/keymap.c",
--             layout = {
--                 "x x x x x",
--             },
--         }
--     end,
-- })
