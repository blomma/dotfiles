return {
    "nvim-neo-tree/neo-tree.nvim",
    -- Replace sources; preserve AstroNvim's event-handler merging.
    opts_extend = { "event_handlers" },
    opts = {
        sources = { "filesystem", "buffers", "git_status" },
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
            filtered_items = {
                visible = true, -- show filtered entries with different styling
                hide_dotfiles = false,
                hide_gitignored = false, -- Show gitignored files
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                },
            },
            follow_current_file = {
                enabled = true,
            },
        },
        default_component_configs = {
            indent = {
                with_markers = true,
            },
        },
    },
}
