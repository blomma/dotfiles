-- WGSL / WESL shaders (Bevy)
-- --------------------------
-- Bevy shaders are written in WESL (`.wesl`), which adds `import` statements
-- and qualified paths (`constants::FOO`) on top of WGSL. Neither Neovim nor
-- nvim-treesitter know about WESL, so this registers the upstream
-- tree-sitter-wesl grammar (which also parses plain WGSL and Bevy's legacy
-- `#import`) and attaches wgsl-analyzer to both filetypes.

---@type LazySpec
return {
    {
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            filetypes = { extension = { wesl = "wesl" } },
            treesitter = { ensure_installed = { "wesl" } },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "TSUpdate",
                desc = "Register the tree-sitter-wesl parser",
                callback = function()
                    require("nvim-treesitter.parsers").wesl = {
                        install_info = {
                            url = "https://github.com/webgpu-tools/tree-sitter-wesl",
                            revision = "b600a65818e4dd7f4d32407d1427643c27f3c389",
                            queries = "queries/nvim",
                        },
                    }
                end,
            })
            vim.treesitter.language.register("wesl", { "wesl", "wgsl" })
        end,
    },
    {
        "AstroNvim/astrolsp",
        optional = true,
        ---@type AstroLSPOpts
        opts = {
            config = {
                wgsl_analyzer = {
                    filetypes = { "wgsl", "wesl" },
                    -- wgsl-analyzer can't resolve Bevy's built-in shader
                    -- modules (`bevy_sprite_render::...`), so semantic
                    -- diagnostics are mostly false "not found" errors.
                    init_options = {
                        diagnostics = { semanticErrors = false },
                    },
                },
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed = require("astrocore").list_insert_unique(
                opts.ensure_installed,
                { "wgsl-analyzer" }
            )
        end,
    },
}
