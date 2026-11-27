-- C# / .NET
-- ---------
-- easy-dotnet.nvim drives the .NET workflow. It starts Microsoft's Roslyn
-- language server as the `easy_dotnet` LSP client,
-- runs tests, builds and runs projects, manages NuGet packages and user
-- secrets, and registers an nvim-dap adapter. Roslyn, the debuggers (native
-- osx-arm64 netcoredbg) and the test host ship inside the EasyDotnet dotnet
-- tool (`dotnet tool install -g EasyDotnet`), so none of it comes from Mason.
--
-- Formatting: Roslyn formats according to `.editorconfig`. Projects that opt
-- into CSharpier (a `.csharpierrc*` file, or CSharpier in a dotnet tool
-- manifest) are formatted by CSharpier instead, preferring the version the
-- manifest pins over the global tool.

local csharpier_config_files = {
    ".csharpierrc",
    ".csharpierrc.json",
    ".csharpierrc.yaml",
    ".csharpierrc.yml",
}
local tool_manifests = { ".config/dotnet-tools.json", "dotnet-tools.json" }

---@param path string
---@return table?
local function read_json(path)
    local fd = io.open(path, "r")
    if not fd then return nil end
    local content = fd:read "*a"
    fd:close()
    local ok, decoded = pcall(vim.json.decode, content)
    return ok and type(decoded) == "table" and decoded or nil
end

--- How CSharpier applies to files in `dir`: "local" when a dotnet tool
--- manifest pins it, "global" when only a CSharpier config file opts in, and
--- nil when the project does not use CSharpier. Manifests are resolved the way
--- `dotnet tool` does: upwards from `dir`, stopping at one marked `isRoot`.
---@param dir string
---@return "local"|"global"|nil
local function csharpier_mode(dir)
    local mode
    local current = dir
    while current do
        if not mode then
            for _, name in ipairs(csharpier_config_files) do
                if vim.uv.fs_stat(vim.fs.joinpath(current, name)) then
                    mode = "global"
                    break
                end
            end
        end
        for _, name in ipairs(tool_manifests) do
            local manifest = read_json(vim.fs.joinpath(current, name))
            if manifest then
                if vim.tbl_get(manifest, "tools", "csharpier") then
                    return "local"
                end
                if manifest.isRoot then return mode end
            end
        end
        local parent = vim.fs.dirname(current)
        current = parent ~= current and parent or nil
    end
    return mode
end

---@param bufnr integer
---@return string
local function buf_dir(bufnr)
    return vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
end

--- Buffer-local `<Leader>N` (.NET) mappings for C#, Razor and MSBuild buffers.
---@param bufnr integer
local function set_dotnet_mappings(bufnr)
    local function dotnet(args, desc)
        return { "<Cmd>Dotnet " .. args .. "<CR>", desc = desc }
    end
    require("astrocore").set_mappings({
        n = {
            ["<Leader>N"] = { desc = "󰪮 .NET" },
            ["<Leader>Np"] = { "<Cmd>Dotnet<CR>", desc = "Command palette" },
            ["<Leader>Nb"] = dotnet("build", "Build project"),
            ["<Leader>NB"] = dotnet("build solution", "Build solution"),
            ["<Leader>Nq"] = dotnet(
                "build solution quickfix",
                "Build solution to quickfix"
            ),
            ["<Leader>Nr"] = dotnet("run", "Run project"),
            ["<Leader>NR"] = dotnet("run profile", "Run with launch profile"),
            ["<Leader>Nw"] = dotnet("watch", "Watch project"),
            ["<Leader>Nd"] = dotnet("debug", "Debug project"),
            ["<Leader>Nc"] = dotnet("clean", "Clean"),
            ["<Leader>Ns"] = dotnet("restore", "Restore packages"),
            ["<Leader>Na"] = dotnet("add package", "Add NuGet package"),
            ["<Leader>Nx"] = dotnet("remove package", "Remove NuGet package"),
            ["<Leader>No"] = { desc = "Outdated packages" },
            ["<Leader>Noo"] = dotnet("outdated", "Show outdated packages"),
            ["<Leader>Nn"] = dotnet("new", "New project from template"),
            ["<Leader>Nf"] = {
                function()
                    require("easy-dotnet").create_new_item(
                        vim.fn.expand "%:p:h"
                    )
                end,
                desc = "New file from template here",
            },
            ["<Leader>NS"] = dotnet("solution select", "Select solution"),
            ["<Leader>Nk"] = dotnet("secrets", "Edit user secrets"),
            ["<Leader>Nu"] = dotnet("lsp fixusings", "Remove unused usings"),
            ["<Leader>NT"] = dotnet(
                "terminal toggle",
                "Toggle output terminal"
            ),
            ["<Leader>Nt"] = { desc = "Tests" },
            ["<Leader>Ntt"] = dotnet("testrunner", "Toggle test runner"),
            ["<Leader>Nts"] = dotnet("test solution", "Test solution"),
        },
    }, { buffer = bufnr })
end

---@type LazySpec
return {
    {
        "AstroNvim/astrocore",
        optional = true,
        ---@type AstroCoreOpts
        opts = {
            treesitter = {
                -- json5: easy-dotnet maps appsettings*.json and
                -- launchSettings.json to json5 so comments are allowed.
                -- sql: injected into string literals.
                ensure_installed = { "c_sharp", "razor", "xml", "json5", "sql" },
            },
            autocmds = {
                dotnet_mappings = {
                    {
                        event = "FileType",
                        pattern = { "cs", "razor" },
                        desc = "Add .NET mappings",
                        callback = function(args) set_dotnet_mappings(args.buf) end,
                    },
                    {
                        event = { "BufRead", "BufNewFile" },
                        pattern = {
                            "*.csproj",
                            "*.props",
                            "*.targets",
                            "*.sln",
                            "*.slnx",
                        },
                        desc = "Add .NET mappings",
                        callback = function(args) set_dotnet_mappings(args.buf) end,
                    },
                },
            },
        },
    },
    {
        "AstroNvim/astrolsp",
        optional = true,
        ---@param opts AstroLSPOpts
        opts = function(_, opts)
            -- Roslyn reads these through `workspace/configuration`;
            -- easy-dotnet merges them into the `easy_dotnet` client config.
            opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
                easy_dotnet = {
                    settings = {
                        ["csharp|inlay_hints"] = {
                            csharp_enable_inlay_hints_for_types = true,
                            csharp_enable_inlay_hints_for_implicit_variable_types = true,
                            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                            csharp_enable_inlay_hints_for_implicit_object_creation = true,
                            dotnet_enable_inlay_hints_for_parameters = true,
                            dotnet_enable_inlay_hints_for_literal_parameters = true,
                            dotnet_enable_inlay_hints_for_indexer_parameters = true,
                            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                            dotnet_enable_inlay_hints_for_other_parameters = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                        },
                        ["csharp|code_lens"] = {
                            dotnet_enable_references_code_lens = true,
                        },
                        ["csharp|completion"] = {
                            dotnet_show_completion_items_from_unimported_namespaces = true,
                            dotnet_show_name_completion_suggestions = true,
                        },
                        ["csharp|background_analysis"] = {
                            -- Compiler errors for the whole solution, analyzer
                            -- diagnostics only for open files (they are costly).
                            -- Neovim pulls the solution-wide ones live via
                            -- workspace/diagnostic; use <Leader>lD to list
                            -- them. Avoid `:Dotnet diagnostic`: it is a
                            -- one-off snapshot from the EasyDotnet server's
                            -- own, older compiler (Roslyn 5.6 in 3.4.38), so
                            -- it duplicates these and reports false errors
                            -- for newer C# (e.g. unions in Hermes).
                            dotnet_compiler_diagnostics_scope = "fullSolution",
                            dotnet_analyzer_diagnostics_scope = "openFiles",
                        },
                        ["csharp|symbol_search"] = {
                            dotnet_search_reference_assemblies = true,
                        },
                    },
                },
            })

            -- Defer to CSharpier (via none-ls) in projects that use it.
            -- easy-dotnet runs one Roslyn client per solution root, so the
            -- decision is made per client.
            opts.formatting = opts.formatting or {}
            local filter = opts.formatting.filter
            opts.formatting.filter = function(client)
                if filter and not filter(client) then return false end
                if client.name == "easy_dotnet" and client.root_dir then
                    return csharpier_mode(client.root_dir) == nil
                end
                return true
            end
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            local null_ls = require "null-ls"
            opts.sources =
                require("astrocore").list_insert_unique(opts.sources, {
                    null_ls.builtins.formatting.csharpier.with {
                        runtime_condition = function(params)
                            return csharpier_mode(buf_dir(params.bufnr)) ~= nil
                        end,
                        dynamic_command = function(params, done)
                            local mode = csharpier_mode(buf_dir(params.bufnr))
                            if mode == "local" then return done "dotnet" end
                            if vim.fn.executable "csharpier" == 1 then
                                return done "csharpier"
                            end
                            vim.notify_once(
                                "Project uses CSharpier but it is not installed: "
                                    .. "dotnet tool install -g csharpier",
                                vim.log.levels.WARN
                            )
                            done(nil)
                        end,
                        args = function(params)
                            -- --stdin-path lets CSharpier resolve .csharpierrc,
                            -- .editorconfig and .csharpierignore for the file.
                            local args = {
                                "format",
                                "--write-stdout",
                                "--stdin-path",
                                params.bufname,
                            }
                            if params.command == "dotnet" then
                                table.insert(args, 1, "csharpier")
                            end
                            return args
                        end,
                        -- `dotnet csharpier` finds the tool manifest from its cwd.
                        cwd = function(params) return buf_dir(params.bufnr) end,
                    },
                })
        end,
    },
    {
        "GustavEikaas/easy-dotnet.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/snacks.nvim",
            "mfussenegger/nvim-dap",
            -- astrolsp must configure `easy_dotnet` before the plugin reads it.
            "AstroNvim/astrolsp",
        },
        ft = { "cs", "razor" },
        cmd = "Dotnet",
        event = {
            {
                event = "BufReadPre",
                pattern = {
                    "*.csproj",
                    "*.props",
                    "*.targets",
                    "*.sln",
                    "*.slnx",
                },
            },
        },
        opts = {
            picker = "snacks",
            lsp = {
                -- The bundled Roslynator reports rules no project build
                -- runs. Without it the editor shows what the build enforces:
                -- compiler, IDE and SDK (CA) diagnostics plus the project's
                -- own analyzer packages.
                roslynator_enabled = false,
            },
            -- Modern C# (10+) default for new files.
            auto_bootstrap_namespace = { type = "file_scoped" },
            test_runner = {
                -- Test-file mappings default to <leader>r/t/d/p, which shadow
                -- AstroNvim's Debugger, Terminal and Packages groups.
                mappings = {
                    run_test_from_buffer = {
                        lhs = "<Leader>Ntr",
                        desc = "Run test",
                    },
                    run_all_tests_from_buffer = {
                        lhs = "<Leader>Ntf",
                        desc = "Run tests in file",
                    },
                    debug_test_from_buffer = {
                        lhs = "<Leader>Ntd",
                        desc = "Debug test",
                    },
                    peek_stack_trace_from_buffer = {
                        lhs = "<Leader>Ntp",
                        desc = "Peek test output",
                    },
                },
            },
            outdated = {
                -- Defaults (<leader>pu / <leader>pa) shadow AstroNvim's
                -- "Lazy check updates" and "Update Lazy and Mason".
                mappings = {
                    upgrade = {
                        lhs = "<Leader>Nou",
                        desc = "Upgrade package under cursor",
                    },
                    upgrade_all = {
                        lhs = "<Leader>Noa",
                        desc = "Upgrade all outdated packages",
                    },
                },
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        optional = true,
        opts = function(_, opts)
            -- vscode-html-language-server: easy-dotnet bridges Razor markup
            -- requests to it.
            opts.ensure_installed = require("astrocore").list_insert_unique(
                opts.ensure_installed,
                { "html-lsp" }
            )
        end,
    },
}
