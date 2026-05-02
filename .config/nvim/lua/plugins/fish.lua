return {
    {
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            treesitter = { ensure_installed = { "fish" } },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            local nls = require "null-ls"
            if not opts.sources then opts.sources = {} end
            opts.sources = vim.list_extend(opts.sources, {
                nls.builtins.formatting.fish_indent,
                nls.builtins.diagnostics.fish,
            })
        end,
    },
}
