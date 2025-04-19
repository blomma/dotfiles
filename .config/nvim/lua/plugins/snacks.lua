return {
    "folke/snacks.nvim",
    opts = function(_, opts)
        return require("astrocore").extend_tbl(opts, {
            indent = {
                indent = {
                    enabled = false,
                    only_scope = true, -- only show indent guides of the scope
                    only_current = true, -- only show indent guides in the current window
                },
                scope = {
                    enabled = true,
                    only_current = true, -- only show scope in the current window
                },
            },
        })
    end,
}
