return {
    "folke/snacks.nvim",
    opts = function(_, opts)
        local get_icon = require("astroui").get_icon
        local art = require "dashboard_art"
        local bofh = require "dashboard_art.bofh"
        local gallery = require "dashboard_art.gallery"
        -- any name from `gallery.order`, or "random" for a new piece per session
        local default_dashboard_header = "random"
        -- picked once so redraws and header cycling keep the same quote
        local dashboard_quote = bofh[art.rng()(1, #bofh)]

        local function get_dashboard_header_name()
            local name = vim.g.snacks_dashboard_header
            if not gallery.pieces[name] then
                name = gallery.pieces[default_dashboard_header]
                        and default_dashboard_header
                    or gallery.order[art.rng()(1, #gallery.order)]
                -- remember the pick so redraws and cycling start from it
                vim.g.snacks_dashboard_header = name
            end
            return name
        end

        --- Break `text` at the space that leaves two lines closest in length.
        ---@param text string
        ---@return string[]
        local function split_balanced(text)
            local split, shortest
            for space in text:gmatch "() " do
                local longest = math.max(space - 1, #text - space)
                if not split or longest < shortest then
                    split, shortest = space, longest
                end
            end
            if not split then return { text } end
            return {
                vim.trim(text:sub(1, split - 1)),
                vim.trim(text:sub(split + 1)),
            }
        end

        -- The art, cwd and quote across the top, over the two columns below.
        -- Snacks only knows columns (panes) filled from the top, so this lives
        -- in pane 1 and a spacer of the same height pushes pane 2 below it.
        ---@param dashboard snacks.dashboard.Class
        local function dashboard_banner(dashboard)
            local opts = dashboard.opts
            local window_width = dashboard:size().width
            -- the same test snacks uses to decide if a second pane fits
            local has_columns = window_width >= opts.width * 2 + opts.pane_gap

            -- Snacks centres a line on pane 1 and starts one as wide as the
            -- window at column 0, so pad to that to centre on the window.
            local function span_window(line)
                if not has_columns then return line end
                local width = 0
                for _, text in ipairs(line) do
                    width = width + vim.api.nvim_strwidth(text[1])
                end
                local left = math.floor((window_width - width) / 2)
                local padded = { { (" "):rep(left) } }
                vim.list_extend(padded, line)
                padded[#padded + 1] = { (" "):rep(window_width - width - left) }
                return padded
            end

            local header = { align = "center", padding = { 1, 1 } }
            for _, line in
                ipairs(art.render(gallery.pieces[get_dashboard_header_name()]))
            do
                header[#header + 1] = { text = span_window(line) }
            end

            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
            if vim.fn.strdisplaywidth(cwd) > 40 then
                cwd = vim.fn.pathshorten(cwd)
            end

            local banner = {
                header,
                {
                    text = span_window {
                        { "󰉋  ", hl = "SnacksDashboardIcon" },
                        { cwd, hl = "SnacksDashboardDir" },
                    },
                    align = "center",
                },
            }

            local quote = { dashboard_quote }
            if vim.api.nvim_strwidth(dashboard_quote) > window_width then
                quote = split_balanced(dashboard_quote)
            end
            for _, line in ipairs(quote) do
                banner[#banner + 1] = {
                    text = span_window {
                        { line, hl = "SnacksDashboardFooter" },
                    },
                    align = "center",
                }
            end
            banner[#banner].padding = { 1, 0 }

            if has_columns then
                -- art plus its padding (2), cwd (1), quote and its padding (1);
                -- the spacer's own line counts as one of those
                banner[#banner + 1] =
                    { pane = 2, padding = #header + #quote + 3 }
            end
            return banner
        end

        local function cycle_dashboard_header(dashboard)
            local index = vim.fn.index(
                gallery.order,
                get_dashboard_header_name()
            ) + 1
            vim.g.snacks_dashboard_header =
                gallery.order[index % #gallery.order + 1]
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
                    dashboard_banner,
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
