return {
    "nvim-neo-tree/neo-tree.nvim",
    -- Replace sources; preserve AstroNvim's event-handler merging.
    opts_extend = { "event_handlers" },
    opts = {
        sources = { "filesystem" },
        enable_git_status = false,
        filesystem = {
            filtered_items = {
                visible = true, -- show filtered entries with different styling
                hide_dotfiles = false,
                hide_gitignored = true,
            },
        },
    },
}
