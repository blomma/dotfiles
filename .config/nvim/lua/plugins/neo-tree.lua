return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
        return require("astrocore").extend_tbl(opts, {
            sources = {
                "filesystem",
            },
            enable_git_status = false,
            filesystem = {
                filtered_items = {
                    visible = true, -- when true, they will just be displayed differently than normal items
                    force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
                    show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_hidden = true, -- only works on Windows for hidden files/directories
                    hide_by_name = {
                        ".DS_Store",
                        "thumbs.db",
                    },
                    hide_by_pattern = { -- uses glob style patterns
                        --"*.meta",
                        --"*/src/*/tsconfig.json"
                    },
                    always_show = { -- remains visible even if other settings would normally hide it
                        --".gitignored",
                    },
                    always_show_by_pattern = { -- uses glob style patterns
                        --".env*",
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                        --".DS_Store",
                        --"thumbs.db"
                    },
                    never_show_by_pattern = { -- uses glob style patterns
                        --".null-ls_*",
                    },
                },
            },
        })
    end,
}
