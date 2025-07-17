return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        -- Configure project root detection, check status with `:AstroRootInfo`
        rooter = {
            -- list of detectors in order of prevalence, elements can be:
            --   "lsp" : lsp detection
            --   string[] : a list of directory patterns to look for
            --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
            detector = {
                "lsp", -- highest priority is getting workspace from running language servers
                { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
                { "lua", "MakeFile", "package.json" }, -- lastly check for known project root files
                -- fallback to parent directory
                function(bufnr)
                    -- get parent directory
                    local parent = vim.uv.fs_realpath(
                        vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
                    )
                    -- if parent directory exists then return it as the root
                    if parent and vim.uv.fs_stat(parent) then return parent end
                end,
            },
            -- ignore things from root detection
            ignore = {
                servers = {}, -- list of language server names to ignore (Ex. { "efm" })
                dirs = {}, -- list of directory patterns (Ex. { "~/.cargo/*" })
            },
            -- automatically update working directory (update manually with `:AstroRoot`)
            autochdir = true,
            -- scope of working directory to change ("global"|"tab"|"win")
            scope = "global",
            -- show notification on every working directory change
            notify = false,
        },
    },
}
