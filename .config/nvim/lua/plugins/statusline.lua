-- A colourful "candy pill" statusline. Every section is a rounded pill made of
-- a saturated icon cap and a softer body. Accents are pulled from the active
-- colorscheme's syntax groups, so the palette follows whatever theme is
-- loaded. The mode pill and the position pill bookend the bar in the colour
-- of the current mode, and the file pill takes the colour of its filetype.

local CAP_LEFT, CAP_RIGHT = "", ""

-- mode colour name (see astroui `status.modes`) -> astroui icon kind
local MODE_ICONS = {
    normal = "VimIcon",
    insert = "ModeInsert",
    visual = "ModeVisual",
    replace = "ModeReplace",
    command = "ModeCommand",
    terminal = "ModeTerminal",
    inactive = "ModeInactive",
}

local function redraw_status() vim.schedule(vim.cmd.redrawstatus) end

---@param group string
---@param attribute "fg"|"bg"
---@param fallback string
---@return string
local function hl_color(group, attribute, fallback)
    local color = require("astroui").get_hlgroup(group)[attribute]
    if type(color) == "number" then return ("#%06x"):format(color) end
    return (color and color ~= "NONE") and color or fallback
end

---@class PillSpec
---@field accent string|(fun(self: table): string) heirline colour name or hex
---@field icon string|(fun(self: table): string)
---@field body table heirline component(s) rendered inside the pill
---@field side "left"|"right" which side of the pill gets the spacing gap
---@field solid? boolean paint the body in the accent colour instead of `pill_bg`
---@field condition? fun(self: table): boolean
---@field init? fun(self: table)
---@field update? table
---@field on_click? table

--- Build a pill: `(icon)` cap in the accent colour followed by a body that
--- sits on `pill_bg`, or on the accent itself when `solid` is set.
---@param spec PillSpec
---@return table
local function pill(spec)
    local function accent(self)
        if type(spec.accent) == "function" then return spec.accent(self) end
        return spec.accent
    end
    local body_bg = spec.solid and accent or function() return "pill_bg" end
    -- heirline walks children with ipairs, so optional parts are appended
    -- rather than written inline as `cond and child or nil`
    local component = {
        condition = spec.condition,
        init = spec.init,
        update = spec.update,
        on_click = spec.on_click,
    }
    if spec.side == "right" then table.insert(component, { provider = " " }) end
    table.insert(component, {
        provider = CAP_LEFT,
        hl = function(self) return { fg = accent(self), bg = "bg" } end,
    })
    table.insert(component, {
        provider = function(self)
            local icon = type(spec.icon) == "function" and spec.icon(self)
                or spec.icon
            return icon .. " "
        end,
        hl = function(self)
            return { fg = "bg", bg = accent(self), bold = true }
        end,
    })
    if not spec.solid then
        table.insert(component, {
            provider = CAP_RIGHT,
            hl = function(self) return { fg = accent(self), bg = "pill_bg" } end,
        })
    end
    table.insert(component, {
        hl = function(self) return { bg = body_bg(self) } end,
        spec.body,
    })
    table.insert(component, {
        provider = CAP_RIGHT,
        hl = function(self) return { fg = body_bg(self), bg = "bg" } end,
    })
    if spec.side == "left" then table.insert(component, { provider = " " }) end
    return component
end

return {
    {
        "AstroNvim/astroui",
        ---@type AstroUIOpts
        opts = {
            icons = {
                VimIcon = "",
                ModeInsert = "",
                ModeVisual = "",
                ModeReplace = "",
                ModeCommand = "",
                ModeTerminal = "",
                ModeInactive = "",
                ScrollText = "",
                GitBranch = "",
                GitAdd = "",
                GitChange = "",
                GitDelete = "",
            },
            status = {
                separators = {
                    tab = { "", "" },
                },
                colors = function(hl)
                    local fallback =
                        assert(require("astroui").config.status.fallback_colors)
                    hl.blue = hl_color("Function", "fg", fallback.blue)
                    hl.green = hl_color("String", "fg", fallback.green)
                    hl.mauve = hl_color("Keyword", "fg", fallback.purple)
                    hl.peach = hl_color("Constant", "fg", fallback.orange)
                    hl.yellow = hl_color("Type", "fg", fallback.yellow)
                    hl.pink = hl_color("Special", "fg", fallback.bright_purple)
                    hl.teal = hl_color("Character", "fg", fallback.green)
                    hl.red = hl_color("Error", "fg", fallback.red)
                    hl.dim = hl_color("Comment", "fg", fallback.grey)
                    hl.pill_bg = hl_color(
                        "PmenuSel",
                        "bg",
                        hl_color("CursorLine", "bg", fallback.dark_bg)
                    )
                    -- give every mode its own hue from the same palette
                    hl.normal = hl.blue
                    hl.insert = hl.green
                    hl.visual = hl.mauve
                    hl.replace = hl.red
                    hl.command = hl.peach
                    hl.terminal = hl.teal
                    hl.inactive = hl.dim
                    return hl
                end,
            },
        },
    },
    {
        "rebelot/heirline.nvim",
        opts = function(_, opts)
            local status = require "astroui.status"
            local get_icon = require("astroui").get_icon
            local condition = status.condition
            local provider = status.provider

            local function mode_color() return status.hl.mode_bg() end

            local mode = pill {
                side = "left",
                solid = true,
                accent = mode_color,
                icon = function()
                    return get_icon(MODE_ICONS[mode_color()] or "VimIcon")
                end,
                body = {
                    provider = provider.mode_text { padding = { right = 1 } },
                    hl = { fg = "bg", bold = true },
                },
                update = {
                    "ModeChanged",
                    pattern = "*:*",
                    callback = redraw_status,
                },
            }

            local file = pill {
                side = "left",
                init = function(self)
                    local icon, color = status.utils.icon_provider(0)
                    self.file_icon = icon or get_icon "DefaultFile"
                    self.file_color = (color and color ~= "NONE") and color
                        or "pink"
                end,
                accent = function(self) return self.file_color end,
                icon = function(self) return self.file_icon end,
                body = {
                    {
                        provider = provider.filename {
                            fallback = "Empty",
                            padding = { left = 1, right = 1 },
                        },
                        hl = { fg = "fg", bold = true },
                    },
                    {
                        condition = condition.file_modified,
                        provider = "● ",
                        hl = { fg = "peach" },
                    },
                    {
                        condition = condition.file_read_only,
                        provider = get_icon "FileReadOnly" .. " ",
                        hl = { fg = "red" },
                    },
                },
            }

            ---@param body table
            local function git_pill(body)
                return pill {
                    side = "left",
                    condition = condition.is_git_repo,
                    init = status.init.update_events { "BufEnter" },
                    update = {
                        "User",
                        pattern = {
                            "GitSignsUpdate",
                            "GitSignsChanged",
                            "MiniDiffUpdated",
                        },
                        callback = redraw_status,
                    },
                    accent = "mauve",
                    icon = get_icon "GitBranch",
                    body = body,
                }
            end

            local git_branch = {
                provider = provider.git_branch {
                    padding = { left = 1, right = 1 },
                },
                hl = { fg = "mauve", bold = true },
            }

            local git = {
                flexible = 15,
                git_pill {
                    git_branch,
                    {
                        provider = provider.git_diff {
                            type = "added",
                            icon = { kind = "GitAdd", padding = { right = 1 } },
                            padding = { right = 1 },
                        },
                        hl = { fg = "git_added" },
                    },
                    {
                        provider = provider.git_diff {
                            type = "changed",
                            icon = {
                                kind = "GitChange",
                                padding = { right = 1 },
                            },
                            padding = { right = 1 },
                        },
                        hl = { fg = "git_changed" },
                    },
                    {
                        provider = provider.git_diff {
                            type = "removed",
                            icon = {
                                kind = "GitDelete",
                                padding = { right = 1 },
                            },
                            padding = { right = 1 },
                        },
                        hl = { fg = "git_removed" },
                    },
                },
                git_pill { git_branch },
            }

            -- cmdheight is 0, so the statusline is the only place these show up
            local macro = pill {
                side = "right",
                condition = condition.is_macro_recording,
                update = {
                    "RecordingEnter",
                    "RecordingLeave",
                    callback = redraw_status,
                },
                accent = "red",
                icon = get_icon "MacroRecording",
                body = {
                    provider = provider.macro_recording {
                        padding = { left = 1, right = 1 },
                    },
                    hl = { fg = "red", bold = true },
                },
            }

            local search = pill {
                side = "right",
                condition = function(self)
                    if not condition.is_hlsearch() then return false end
                    local ok, count = pcall(vim.fn.searchcount)
                    self.search = ok and count or nil
                    return self.search ~= nil and (self.search.total or 0) > 0
                end,
                accent = "yellow",
                icon = get_icon "Search",
                body = {
                    provider = function(self)
                        local count = self.search
                        return (" %s%d/%s%d "):format(
                            count.current > count.maxcount and ">" or "",
                            math.min(count.current, count.maxcount),
                            count.incomplete == 2 and ">" or "",
                            math.min(count.total, count.maxcount)
                        )
                    end,
                    hl = { fg = "yellow", bold = true },
                },
            }

            local lsp_progress = status.component.lsp {
                lsp_client_names = false,
                lsp_progress = { padding = { left = 1 } },
                hl = { fg = "teal" },
                surround = { separator = "none", color = "bg" },
            }

            local diagnostics = {
                condition = condition.has_diagnostics,
                update = { "DiagnosticChanged", "BufEnter" },
            }
            for _, severity in ipairs { "ERROR", "WARN", "INFO", "HINT" } do
                table.insert(diagnostics, {
                    provider = provider.diagnostics {
                        severity = severity,
                        icon = {
                            kind = "Diagnostic"
                                .. severity:sub(1, 1)
                                .. severity:sub(2):lower(),
                            padding = { right = 1 },
                        },
                        padding = { left = 1 },
                    },
                    hl = { fg = "diag_" .. severity },
                })
            end

            local lsp = pill {
                side = "right",
                condition = condition.lsp_attached,
                update = { "LspAttach", "LspDetach", "BufEnter" },
                accent = "teal",
                icon = get_icon "ActiveLSP",
                body = {
                    provider = provider.lsp_client_names {
                        padding = { left = 1, right = 1 },
                    },
                    hl = { fg = "teal" },
                },
            }

            local cwd = pill {
                side = "right",
                accent = "peach",
                icon = get_icon "FolderOpen",
                body = {
                    provider = function()
                        local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                        return " " .. name:gsub("%%", "%%%%") .. " "
                    end,
                    hl = { fg = "peach", bold = true },
                },
            }

            ---@param body table
            local function position_pill(body)
                return pill {
                    side = "right",
                    accent = mode_color,
                    icon = get_icon "ScrollText",
                    body = body,
                }
            end

            local position = {
                flexible = 20,
                position_pill {
                    {
                        provider = provider.ruler { padding = { left = 1 } },
                        hl = { fg = "fg", bold = true },
                    },
                    {
                        provider = provider.percentage { padding = { left = 1 } },
                        hl = { fg = "dim" },
                    },
                    {
                        provider = provider.scrollbar {
                            padding = { left = 1, right = 1 },
                        },
                        hl = function() return { fg = mode_color() } end,
                    },
                },
                position_pill {
                    provider = provider.ruler {
                        padding = { left = 1, right = 1 },
                    },
                    hl = { fg = "fg", bold = true },
                },
            }

            opts.statusline = {
                hl = { fg = "fg", bg = "bg" },
                mode,
                file,
                git,
                status.component.fill(),
                macro,
                search,
                lsp_progress,
                status.component.fill(),
                diagnostics,
                -- as the window narrows, shed in this order: cwd, LSP clients,
                -- git diff counts, scroll percentage and bar
                { flexible = 10, lsp, {} },
                { flexible = 5, cwd, {} },
                position,
            }
        end,
    },
}
