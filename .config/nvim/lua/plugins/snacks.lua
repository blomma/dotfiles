return {
    "folke/snacks.nvim",
    opts = function(_, opts)
        local get_icon = require("astroui").get_icon
        local default_dashboard_header = "falcon" -- astro | falcon | enterprise | firehouse
        local dashboard_header_order =
            { "astro", "falcon", "enterprise", "firehouse" }

        local function pixel(text, hl) return { { text, hl = hl } } end
        local function canvas(text, width)
            local padding = math.max(width - vim.fn.strdisplaywidth(text), 0)
            return text .. (" "):rep(padding)
        end
        local function center(text, width)
            local padding = math.max(width - vim.fn.strdisplaywidth(text), 0)
            local left = math.floor(padding / 2)
            return (" "):rep(left) .. text .. (" "):rep(padding - left)
        end
        local function firehouse_floor(text)
            return "║" .. center(text, 38) .. "║"
        end
        local firehouse_border = ("═"):rep(38)

        -- stylua: ignore
        local dashboard_headers = {
            astro = {
                pixel("✦          ·          ✧", "SnacksDashboardFooter"),
                pixel("▄████▄", "SnacksDashboardHeader"),
                pixel("▄▄████████▄▄", "SnacksDashboardHeader"),
                pixel("▄████████████████▄", "SnacksDashboardIcon"),
                pixel("████  ████████  ████", "SnacksDashboardIcon"),
                pixel("▀██████████████████▀", "SnacksDashboardKey"),
                pixel("▀▀███▀▀▀▀███▀▀", "SnacksDashboardKey"),
                pixel("▀  ▀▀  ▀", "SnacksDashboardFooter"),
                pixel("░▒▓▓▒░", "SnacksDashboardFooter"),
                pixel("A S T R O  //  N V I M", "SnacksDashboardTitle"),
            },
            falcon = {
                -- Adapted from the top-view artwork signed "LS" at:
                -- https://the.sunnyspot.org/asciiart/gallery/starwars.html
                pixel(canvas("✦          ▄     ▄", 32), "SnacksDashboardFooter"),
                pixel(canvas("          ╱█│   │█╲", 32), "SnacksDashboardHeader"),
                pixel(canvas("         ╱ █│   │█ ╲", 32), "SnacksDashboardHeader"),
                pixel(canvas("        ╱  █│▄▄▄│█  ╲    ▄", 32), "SnacksDashboardIcon"),
                pixel(canvas("       ╱    │   │    ╲  ╱█╲", 32), "SnacksDashboardIcon"),
                pixel(canvas("      ╱ ╭───│   │───╮ ╲╱   │", 32), "SnacksDashboardIcon"),
                pixel(canvas("     ╱╭─╯ ▄▄│   │▄▄ ╰─╮    │", 32), "SnacksDashboardIcon"),
                pixel(canvas("    ╱ ╱    ╲│   │╱    ╲  ╱─╯", 32), "SnacksDashboardKey"),
                pixel(canvas("   │       ╰───╯      │╱", 32), "SnacksDashboardKey"),
                pixel(canvas("   ╰───╮____╱  ◉  ╲____╭───╯", 32), "SnacksDashboardKey"),
                pixel(canvas("    ▓▓▓▓▓▓▓│     │▓▓▓▓▓▓▓", 32), "SnacksDashboardFooter"),
                pixel(canvas("    ╭───~~~~╲     ╱~~~~───╮", 32), "SnacksDashboardFooter"),
                pixel(canvas("     ╲      ╱╲───╱╲      ╱", 32), "SnacksDashboardFooter"),
                pixel(canvas("      ╰──╯         ╰──╯", 32), "SnacksDashboardFooter"),
                pixel("MILLENNIUM FALCON  //  YT-1300", "SnacksDashboardTitle"),
            },
            enterprise = {
                -- Redrawn from the Constitution-class front view at:
                -- https://sunnyspot.org/asciiart/gallery/startrek.html
                pixel("·      ╭──╮                       ╭──╮      ✦", "SnacksDashboardFooter"),
                pixel("│  │        __───__        │  │", "SnacksDashboardHeader"),
                pixel("__╰──╯_____───_______───_____╰──╯__", "SnacksDashboardHeader"),
                pixel("╲_________________________________╱", "SnacksDashboardIcon"),
                pixel("╲╲_   ╲_______╱   _╱╱", "SnacksDashboardIcon"),
                pixel("╲╲_   ╲___╱   _╱╱", "SnacksDashboardIcon"),
                pixel("╲╲__─│ │─__╱╱", "SnacksDashboardKey"),
                pixel("╲╱ ╭───╮ ╲╱", "SnacksDashboardKey"),
                pixel("│ ◉ │", "SnacksDashboardFooter"),
                pixel("╰───╯", "SnacksDashboardFooter"),
                pixel("U.S.S. ENTERPRISE  //  NCC-1701", "SnacksDashboardTitle"),
            },
            firehouse = {
                pixel("╔" .. firehouse_border .. "╗", "DiagnosticError"),
                pixel(firehouse_floor "░▒░  G H O S T B U S T E R S  ░▒░", "SnacksDashboardIcon"),
                pixel("╠" .. firehouse_border .. "╣", "DiagnosticError"),
                pixel(firehouse_floor "╭────╮    ╭────╮    ╭────╮", "SnacksDashboardKey"),
                pixel(firehouse_floor "│ ▐▐ │    │ ▐▐ │    │ ▐▐ │", "SnacksDashboardKey"),
                pixel(firehouse_floor "╰────╯    ╰────╯    ╰────╯", "SnacksDashboardKey"),
                pixel("╠" .. firehouse_border .. "╣", "DiagnosticError"),
                pixel(firehouse_floor "╭────╮  ╔══════════════╗  ╭────╮", "SnacksDashboardIcon"),
                pixel(firehouse_floor "│ ▐▐ │  ║   ⊘ GHOST    ║  │ ▐▐ │", "SnacksDashboardIcon"),
                pixel(firehouse_floor "╰────╯  ║ ┌──────────┐ ║  ╰────╯", "SnacksDashboardKey"),
                pixel(firehouse_floor "║ │ ECTO-1   │ ║", "SnacksDashboardFooter"),
                pixel(firehouse_floor "║ ╰──────────╯ ║", "SnacksDashboardKey"),
                pixel("╚" .. firehouse_border .. "╝", "DiagnosticError"),
                pixel("HOOK & LADDER 8  //  NYC", "SnacksDashboardTitle"),
            },
        }

        local function get_dashboard_header_name()
            local name = vim.g.snacks_dashboard_header
                or default_dashboard_header
            return dashboard_headers[name] and name or default_dashboard_header
        end

        local function dashboard_header()
            local section = { align = "center", padding = { 1, 1 } }
            for _, line in
                ipairs(dashboard_headers[get_dashboard_header_name()])
            do
                section[#section + 1] = { text = line }
            end
            return section
        end

        local function cycle_dashboard_header(dashboard)
            local current = get_dashboard_header_name()
            local index = vim.fn.index(dashboard_header_order, current) + 1
            vim.g.snacks_dashboard_header =
                dashboard_header_order[index % #dashboard_header_order + 1]
            dashboard:update()
        end

        return require("astrocore").extend_tbl(opts, {
            dashboard = {
                width = 48,
                pane_gap = 6,
                preset = {
                    keys = {
                        {
                            icon = get_icon("Search", 0, true),
                            key = "f",
                            desc = "Find File",
                            action = "<Leader>ff",
                        },
                        {
                            icon = get_icon("FileNew", 0, true),
                            key = "n",
                            desc = "New File",
                            action = "<Leader>n",
                        },
                        {
                            icon = get_icon("WordFile", 0, true),
                            key = "g",
                            desc = "Find Text",
                            action = "<Leader>fw",
                        },
                        {
                            icon = get_icon("DefaultFile", 0, true),
                            key = "r",
                            desc = "Recent Files",
                            action = "<Leader>fo",
                        },
                        {
                            icon = get_icon("FolderOpen", 0, true),
                            key = "p",
                            desc = "Projects",
                            action = "<Leader>fp",
                        },
                        {
                            icon = get_icon("Environment", 0, true),
                            key = "c",
                            desc = "Config",
                            action = "<Leader>fa",
                        },
                        {
                            icon = get_icon("Refresh", 0, true),
                            key = "s",
                            desc = "Last Session",
                            action = "<Leader>Sl",
                        },
                        {
                            icon = "󰸌 ",
                            key = "h",
                            desc = "Switch Header",
                            action = cycle_dashboard_header,
                        },
                        {
                            icon = get_icon("Package", 0, true),
                            key = "l",
                            desc = "Lazy",
                            action = ":Lazy",
                        },
                        {
                            icon = "󰩈 ",
                            key = "q",
                            desc = "Quit",
                            action = ":qa",
                        },
                    },
                },
                sections = {
                    dashboard_header,
                    function()
                        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
                        if vim.fn.strdisplaywidth(cwd) > 40 then
                            cwd = vim.fn.pathshorten(cwd)
                        end
                        return {
                            text = {
                                { "󰉋  ", hl = "SnacksDashboardIcon" },
                                { cwd, hl = "SnacksDashboardDir" },
                            },
                            align = "center",
                            padding = { 1, 0 },
                        }
                    end,
                    {
                        icon = " ",
                        title = "Quick Actions",
                        section = "keys",
                        indent = 2,
                        padding = 1,
                    },
                    {
                        pane = 2,
                        icon = get_icon("DefaultFile", 0, true),
                        title = "Recent Files",
                        section = "recent_files",
                        limit = 5,
                        indent = 2,
                        padding = 1,
                    },
                    {
                        pane = 2,
                        icon = get_icon("FolderOpen", 0, true),
                        title = "Projects",
                        section = "projects",
                        limit = 5,
                        indent = 2,
                        padding = 1,
                    },
                    { section = "startup" },
                },
            },
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
            zen = {
                toggles = {
                    dim = false,
                    git_signs = false,
                    mini_diff_signs = false,
                    -- diagnostics = false,
                    -- inlay_hints = false,
                },
            },
            picker = {
                layout = {
                    layout = {
                        backdrop = false,
                        width = 0.8,
                        min_width = 80,
                        height = 0.8,
                        min_height = 30,
                        box = "vertical",
                        border = true,
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                        {
                            win = "preview",
                            title = "{preview}",
                            height = 0.4,
                            border = "top",
                        },
                    },
                },
            },
        })
    end,
}
