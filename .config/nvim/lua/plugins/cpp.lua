local uname = (vim.uv or vim.loop).os_uname()
local is_linux_arm = uname.sysname == "Linux"
    and (uname.machine == "aarch64" or vim.startswith(uname.machine, "arm"))

return {
    {
        "AstroNvim/astrolsp",
        optional = true,
        opts = function(_, opts)
            opts.config = vim.tbl_deep_extend("keep", opts.config, {
                clangd = {
                    capabilities = {
                        offsetEncoding = "utf-8",
                    },
                },
            })
            if is_linux_arm then
                opts.servers = require("astrocore").list_insert_unique(
                    opts.servers,
                    { "clangd" }
                )
            end
        end,
    },
    {
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            treesitter = {
                ensure_installed = { "cpp", "c", "objc", "cuda", "proto" },
            },
        },
    },
    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        dependencies = {
            "AstroNvim/astrocore",
            opts = {
                autocmds = {
                    clangd_extensions = {
                        {
                            event = "LspAttach",
                            desc = "Load clangd_extensions with clangd",
                            callback = function(args)
                                if
                                    assert(
                                        vim.lsp.get_client_by_id(
                                            args.data.client_id
                                        )
                                    ).name
                                    == "clangd"
                                then
                                    require "clangd_extensions"
                                    vim.api.nvim_del_augroup_by_name "clangd_extensions"
                                end
                            end,
                        },
                    },
                    clangd_extension_mappings = {
                        {
                            event = "LspAttach",
                            desc = "Load clangd_extensions with clangd",
                            callback = function(args)
                                if
                                    assert(
                                        vim.lsp.get_client_by_id(
                                            args.data.client_id
                                        )
                                    ).name
                                    == "clangd"
                                then
                                    require("astrocore").set_mappings({
                                        n = {
                                            ["<Leader>lw"] = {
                                                "<Cmd>ClangdSwitchSourceHeader<CR>",
                                                desc = "Switch source/header file",
                                            },
                                        },
                                    }, {
                                        buffer = args.buf,
                                    })
                                end
                            end,
                        },
                    },
                },
            },
        },
    },
    {
        "Civitasv/cmake-tools.nvim",
        lazy = true,
        cmd = {
            "CMakeGenerate",
            "CMakeClean",
            "CMakeBuild",
            "CMakeQuickBuild",
            "CMakeInstall",
            "CMakeStopExecutor",
            "CMakeStopRunner",
            "CMakeCloseExecutor",
            "CMakeCloseRunner",
            "CMakeOpenExecutor",
            "CMakeOpenRunner",
            "CMakeOpenCache",
            "CMakeRun",
            "CMakeQuickRun",
            "CMakeRunCurrentFile",
            "CMakeBuildCurrentFile",
            "CMakeLaunchArgs",
            "CMakeSelectBuildType",
            "CMakeSelectKit",
            "CMakeSelectConfigurePreset",
            "CMakeSelectBuildPreset",
            "CMakeSelectTestPreset",
            "CMakeSelectBuildTarget",
            "CMakeSelectLaunchTarget",
            "CMakeTargetSettings",
            "CMakeSettings",
            "CMakeSelectCwd",
            "CMakeSelectBuildDir",
            "CMakeRunTest",
            "CMakeQuickStart",
        },
        init = function(plugin)
            local group = vim.api.nvim_create_augroup("cmake_tools_lazy", {
                clear = true,
            })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                desc = "Load CMake tooling only for CMake projects",
                pattern = {
                    "c",
                    "cpp",
                    "objc",
                    "objcpp",
                    "cuda",
                    "proto",
                    "cmake",
                },
                callback = function(args)
                    if package.loaded["cmake-tools"] then
                        vim.api.nvim_clear_autocmds { group = group }
                        return
                    end
                    if
                        vim.fs.root(args.buf, {
                            "CMakeLists.txt",
                            "CMakePresets.json",
                        })
                    then
                        require("lazy").load { plugins = { plugin.name } }
                        vim.api.nvim_clear_autocmds { group = group }
                    end
                end,
            })
        end,
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
        },
        opts = {},
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            local tools = { "codelldb" }
            if not is_linux_arm then table.insert(tools, "clangd") end
            opts.ensure_installed = require("astrocore").list_insert_unique(
                opts.ensure_installed,
                tools
            )
        end,
    },
}
