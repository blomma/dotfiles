-- A small drawing engine for the snacks.nvim dashboard header.
--
-- The dashboard accepts a list of lines where every line is a list of
-- `{ text, hl = group }` segments. This module turns art authored as plain
-- strings into such segments, so each cell can carry its own foreground,
-- background and attributes:
--
--   pixel  rows of palette keys; two rows are packed into one terminal line
--          with half blocks (▀ ▄ █), giving square-ish true-colour pixels.
--   glyph  ordinary text art plus optional colour masks (one key per cell)
--          for the foreground and the background.
--   cells  pre-computed cells for procedural art.
--
-- Colours come from a palette resolved against the active colorscheme. Hues
-- are picked by *hue*, not by highlight group name, because themes disagree
-- wildly on which syntax group is which colour (dracula's `Function` is
-- yellow, melange's `String` is lavender). The art stays recognisable (the
-- TARDIS is blue, the invaders are green) while using the theme's own tones.

local M = {}

-- Colour maths -------------------------------------------------------------

---@param hex string "#rrggbb"
---@return number, number, number
local function to_rgb(hex)
    return tonumber(hex:sub(2, 3), 16),
        tonumber(hex:sub(4, 5), 16),
        tonumber(hex:sub(6, 7), 16)
end

---@return string
local function to_hex(r, g, b)
    local function c(v) return math.max(0, math.min(255, math.floor(v + 0.5))) end
    return ("#%02x%02x%02x"):format(c(r), c(g), c(b))
end

--- Mix `a` towards `b`; `t = 0` is `a`, `t = 1` is `b`.
---@param a string
---@param b string
---@param t number
---@return string
function M.blend(a, b, t)
    local ar, ag, ab = to_rgb(a)
    local br, bg, bb = to_rgb(b)
    return to_hex(ar + (br - ar) * t, ag + (bg - ag) * t, ab + (bb - ab) * t)
end

---@param hex string
---@return number hue degrees, number saturation 0-1, number lightness 0-1
local function to_hsl(hex)
    local r, g, b = to_rgb(hex)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local l = (max + min) / 2
    if max == min then return 0, 0, l end
    local d = max - min
    local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    local h
    if max == r then
        h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
        h = (b - r) / d + 2
    else
        h = (r - g) / d + 4
    end
    return h * 60, s, l
end

-- Palette ------------------------------------------------------------------

-- Highlight groups whose foregrounds are mined for theme colours.
local CANDIDATE_GROUPS = {
    "DiagnosticError",
    "DiagnosticWarn",
    "DiagnosticInfo",
    "DiagnosticHint",
    "DiagnosticOk",
    "String",
    "Constant",
    "Number",
    "Function",
    "Keyword",
    "Type",
    "Special",
    "Statement",
    "Operator",
    "Identifier",
    "Character",
    "Boolean",
    "PreProc",
    "Title",
    "Directory",
    "Question",
    "MoreMsg",
    "@variable.builtin",
    "@variable.parameter",
    "@tag",
    "@property",
    "@constructor",
    "@module",
    "@string.special",
    "@function.builtin",
    "@keyword.return",
    "@type.builtin",
    "@punctuation.special",
}

-- Named hues the art is drawn with: target hue in degrees, and a canonical
-- colour used when the theme has nothing within reach of that hue.
local HUES = {
    r = { hue = 355, fallback = "#e8606a" }, -- red
    o = { hue = 22, fallback = "#f0965a" }, -- orange
    y = { hue = 45, fallback = "#e8c46a" }, -- yellow
    g = { hue = 105, fallback = "#8cc265" }, -- green
    t = { hue = 170, fallback = "#5fc4b0" }, -- teal
    c = { hue = 192, fallback = "#6cc8e0" }, -- cyan / sky
    b = { hue = 222, fallback = "#6f9ff0" }, -- blue
    p = { hue = 275, fallback = "#b48cf0" }, -- purple
    m = { hue = 322, fallback = "#f0a0d8" }, -- magenta / pink
}
local HUE_REACH = 28 -- degrees a theme colour may be off before falling back

local function hue_distance(a, b)
    local d = math.abs(a - b) % 360
    return d > 180 and 360 - d or d
end

---@param name string
---@param attr "fg"|"bg"
---@return string?
local function hl_color(name, attr)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    local value = ok and hl[attr]
    return type(value) == "number" and ("#%06x"):format(value) or nil
end

---@return string[]
local function theme_colors()
    local seen, out = {}, {}
    local function add(hex)
        if hex and not seen[hex] then
            seen[hex] = true
            out[#out + 1] = hex
        end
    end
    for _, group in ipairs(CANDIDATE_GROUPS) do
        add(hl_color(group, "fg"))
    end
    for i = 0, 15 do
        local value = vim.g["terminal_color_" .. i]
        if type(value) == "string" and value:match "^#%x%x%x%x%x%x$" then
            add(value:lower())
        end
    end
    return out
end

---@param candidates string[]
---@param target number
---@return string?
local function closest_hue(candidates, target)
    local best, best_score
    for _, hex in ipairs(candidates) do
        local h, s, l = to_hsl(hex)
        -- ignore greys and near-black/near-white tones: they carry no hue
        if s >= 0.22 and l > 0.2 and l < 0.9 then
            local distance = hue_distance(h, target)
            if distance <= HUE_REACH then
                -- prefer close hues, then vivid ones
                local score = distance + (1 - s) * 20
                if not best_score or score < best_score then
                    best, best_score = hex, score
                end
            end
        end
    end
    return best
end

---@class DashboardArtPalette: table<string, string|false>

--- Resolve the drawing palette against the active colorscheme.
---
--- Keys (one character, so they can be used in masks):
---   r o y g t c b p m  red orange yellow green teal cyan blue purple pink
---   R O Y G T C B P M  the same hues in shadow (always darker than the base)
---   w W                foreground, and a higher-contrast version of it
---   L                  light: glowing / white-painted things, bright on
---                      dark and light themes alike
---   s d                comment grey, dim grey
---   + = -              a neutral metal / stone ramp (light, mid, dark) that
---                      keeps its light-to-dark order on any theme, for hulls
---                      and buildings that must not invert on light themes
---   k                  the editor background (false when transparent)
---@return DashboardArtPalette
function M.palette()
    local bg_actual = hl_color("Normal", "bg")
    local light
    if bg_actual then
        light = select(3, to_hsl(bg_actual)) > 0.5
    else
        light = vim.o.background == "light"
    end
    local fg = hl_color("Normal", "fg") or (light and "#3c3c3c" or "#d0d0d0")
    local bg = bg_actual or (light and "#ffffff" or "#000000")
    -- the direction "more contrast" goes in for this theme
    local ink = light and "#000000" or "#ffffff"

    local candidates = theme_colors()
    local pal = {}
    for key, spec in pairs(HUES) do
        local base = closest_hue(candidates, spec.hue) or spec.fallback
        pal[key] = base
        -- on a dark theme shadows sink into the background; on a light one
        -- that would make them paler, so darken towards black instead
        pal[key:upper()] = light and M.blend(base, "#000000", 0.35)
            or M.blend(base, bg, 0.45)
    end
    pal.w = fg
    pal.W = M.blend(fg, ink, 0.6)
    pal.L = light and M.blend(bg, "#ffffff", 0.7) or pal.W
    pal.s = hl_color("Comment", "fg") or M.blend(fg, bg, 0.45)
    pal.d = M.blend(fg, bg, 0.72)
    if light then
        pal["+"] = M.blend(fg, bg, 0.55)
        pal["="] = M.blend(fg, bg, 0.35)
        pal["-"] = M.blend(fg, bg, 0.15)
    else
        pal["+"] = fg
        pal["="] = M.blend(fg, pal.s, 0.5)
        pal["-"] = pal.s
    end
    pal.k = bg_actual or false
    -- extras for art that needs a background colour even on transparent UIs
    pal._bg = bg
    pal._fg = fg
    pal._light = light
    return pal
end

-- Highlight groups ---------------------------------------------------------

---@class DashboardArtStyle
---@field fg? string
---@field bg? string
---@field bold? boolean
---@field italic? boolean
---@field blink? boolean

--- Return (and define) a highlight group for a style. Names are derived from
--- the colours themselves, so a name always means the same thing and the
--- group can be (re)defined on every render: that keeps the art correct even
--- after `:colorscheme` wipes custom groups with `:hi clear`.
---@param style DashboardArtStyle
---@return string?
local function group_for(style)
    if not style.fg and not style.bg then return nil end
    local name = ("DashboardArt_%s_%s%s%s%s"):format(
        style.fg and style.fg:sub(2) or "x",
        style.bg and style.bg:sub(2) or "x",
        style.bold and "b" or "",
        style.italic and "i" or "",
        style.blink and "k" or ""
    )
    vim.api.nvim_set_hl(0, name, {
        fg = style.fg,
        bg = style.bg,
        bold = style.bold,
        italic = style.italic,
        blink = style.blink,
    })
    return name
end

-- Cells & lines ------------------------------------------------------------

---@class DashboardArtCell: DashboardArtStyle
---@field [1] string a single display cell

---@alias DashboardArtRow DashboardArtCell[]

---@param a DashboardArtCell
---@param b DashboardArtCell
local function same_style(a, b)
    return a.fg == b.fg
        and a.bg == b.bg
        and a.bold == b.bold
        and a.italic == b.italic
        and a.blink == b.blink
end

--- Merge runs of identically styled cells into dashboard text segments.
---@param row DashboardArtRow
---@return snacks.dashboard.Text[]
local function segments(row)
    local out = {}
    local run, run_style
    local function flush()
        if run then
            out[#out + 1] = { table.concat(run), hl = group_for(run_style) }
        end
    end
    for _, cell in ipairs(row) do
        -- a blank cell without a background shows nothing, so its foreground
        -- is irrelevant; normalising it lets it merge with neighbours
        local style = cell
        if cell[1] == " " and not cell.bg then style = {} end
        if run and same_style(run_style, style) then
            run[#run + 1] = cell[1]
        else
            flush()
            run, run_style = { cell[1] }, style
        end
    end
    flush()
    return out
end

---@param text string
---@return string[]
local function chars(text) return vim.fn.split(text, "\\zs") end

-- Block renderers ----------------------------------------------------------

---@param pal DashboardArtPalette
---@param colors? table<string, string|fun(pal: DashboardArtPalette): string>
---@return fun(key: string): string|false|nil
local function resolver(pal, colors)
    return function(key)
        if key == "" or key == " " or key == "." then return nil end
        local custom = colors and colors[key]
        if type(custom) == "function" then return custom(pal) end
        if custom then return pal[custom] or custom end
        local value = pal[key]
        if value == nil then
            error(("dashboard art: unknown colour key %q"):format(key))
        end
        return value
    end
end

--- Pack pairs of pixel rows into half-block cells.
---@param block {rows: string[], colors?: table}
---@param pal DashboardArtPalette
---@return DashboardArtRow[]
local function render_pixels(block, pal)
    local color = resolver(pal, block.colors)
    local rows = block.rows
    local width = 0
    for _, row in ipairs(rows) do
        width = math.max(width, #row)
    end
    local out = {}
    for y = 1, #rows, 2 do
        local top_row, bottom_row = rows[y], rows[y + 1] or ""
        local line = {}
        for x = 1, width do
            -- `false` (a transparent editor background) behaves like nothing
            local top = color(top_row:sub(x, x)) or nil
            local bottom = color(bottom_row:sub(x, x)) or nil
            if not top and not bottom then
                line[x] = { " " }
            elseif top == bottom then
                line[x] = { "█", fg = top }
            elseif not bottom then
                line[x] = { "▀", fg = top }
            elseif not top then
                line[x] = { "▄", fg = bottom }
            else
                line[x] = { "▀", fg = top, bg = bottom }
            end
        end
        out[#out + 1] = line
    end
    return out
end

--- Colour text art. The foreground of a cell is, in order of precedence:
--- its key in the `fg` mask, the key `charmap` assigns to its character,
--- the line's entry in `defaults`, and finally `default`.
---@class DashboardArtGlyphBlock
---@field lines string[]
---@field fg? string[] per-cell foreground keys, aligned with `lines`
---@field bg? string[] per-cell background keys, aligned with `lines`
---@field charmap? table<string, string> characters (all of the key string) -> colour key
---@field defaults? table<integer, string> per-line fallback colour key
---@field default? string fallback colour key ("w")
---@field colors? table extra colour keys
---@field bold? boolean
---@field italic? boolean

---@param block DashboardArtGlyphBlock
---@param pal DashboardArtPalette
---@return DashboardArtRow[]
local function render_glyphs(block, pal)
    local color = resolver(pal, block.colors)
    local by_char = {}
    for set, key in pairs(block.charmap or {}) do
        for _, ch in ipairs(chars(set)) do
            by_char[ch] = key
        end
    end
    local out = {}
    for y, text in ipairs(block.lines) do
        local fg_mask = block.fg and block.fg[y] or ""
        local bg_mask = block.bg and block.bg[y] or ""
        local fallback = block.defaults and block.defaults[y]
            or block.default
            or "w"
        local line = {}
        for x, ch in ipairs(chars(text)) do
            if vim.fn.strdisplaywidth(ch) ~= 1 then
                error(
                    ("dashboard art: %q is not one cell wide (line %d)"):format(
                        ch,
                        y
                    )
                )
            end
            local fg_key = fg_mask:sub(x, x)
            if fg_key == "" or fg_key == " " then
                fg_key = by_char[ch] or fallback
            end
            local bg_key = bg_mask:sub(x, x)
            line[x] = {
                ch,
                fg = color(fg_key) or nil,
                bg = color(bg_key) or nil,
                bold = block.bold,
                italic = block.italic,
            }
        end
        out[#out + 1] = line
    end
    return out
end

--- A single line whose colour sweeps across the given palette keys.
---@param block {text: string, stops: string[], bold?: boolean}
---@param pal DashboardArtPalette
---@return DashboardArtRow[]
local function render_gradient(block, pal)
    local color = resolver(pal, block.colors)
    local stops = vim.tbl_map(color, block.stops)
    local letters = chars(block.text)
    local line = {}
    for x, ch in ipairs(letters) do
        local t = #letters > 1 and (x - 1) / (#letters - 1) or 0
        local pos = t * (#stops - 1)
        local i = math.min(math.floor(pos) + 1, #stops - 1)
        local fg = #stops == 1 and stops[1]
            or M.blend(stops[i], stops[i + 1], pos - (i - 1))
        line[x] = { ch, fg = fg, bold = block.bold }
    end
    return { line }
end

local RENDERERS = {
    pixel = render_pixels,
    glyph = render_glyphs,
    gradient = render_gradient,
    cells = function(block) return block.rows end,
}

-- Public API ---------------------------------------------------------------

---@class DashboardArtBlock
---@field [1] "pixel"|"glyph"|"gradient"|"cells"
---@field align? "left"|"center"|"right" placement inside the piece (center)

---@class DashboardArtPiece
---@field blocks DashboardArtBlock[]|fun(pal: DashboardArtPalette): DashboardArtBlock[]

--- Render a piece to dashboard lines. Every line is padded to the width of
--- the widest one, so the dashboard's per-line centring keeps the art intact.
---@param piece DashboardArtPiece
---@return snacks.dashboard.Text[][]
function M.render(piece)
    local pal = M.palette()
    local blocks = piece.blocks
    if type(blocks) == "function" then blocks = blocks(pal) end

    local rows, aligns, width = {}, {}, 0
    for _, block in ipairs(blocks) do
        local renderer = RENDERERS[block[1]]
            or error(("dashboard art: unknown block %q"):format(block[1]))
        for _, row in ipairs(renderer(block, pal)) do
            rows[#rows + 1] = row
            aligns[#rows] = block.align or "center"
            width = math.max(width, #row)
        end
    end

    local lines = {}
    for i, row in ipairs(rows) do
        local padding = width - #row
        local left = aligns[i] == "left" and 0
            or aligns[i] == "right" and padding
            or math.floor(padding / 2)
        local padded = {}
        for _ = 1, left do
            padded[#padded + 1] = { " " }
        end
        vim.list_extend(padded, row)
        for _ = 1, padding - left do
            padded[#padded + 1] = { " " }
        end
        lines[i] = segments(padded)
    end
    return lines
end

M.chars = chars

--- A pixel canvas for composing scenes out of sprites. Coordinates are
--- 0-based; `.` is a transparent pixel.
---@param width integer
---@param height integer
function M.canvas(width, height)
    local grid = {}
    for y = 1, height do
        grid[y] = {}
        for x = 1, width do
            grid[y][x] = "."
        end
    end

    local canvas = {}

    --- Set one pixel; out-of-bounds pixels are clipped.
    ---@param x integer
    ---@param y integer
    ---@param key string
    function canvas.set(x, y, key)
        local row = grid[y + 1]
        if row and row[x + 1] then row[x + 1] = key end
        return canvas
    end

    --- Draw a sprite. `recolor` is either a single key that replaces every
    --- opaque pixel, or a table mapping sprite keys to palette keys.
    ---@param sprite string[]
    ---@param x integer
    ---@param y integer
    ---@param recolor? string|table<string, string>
    function canvas.stamp(sprite, x, y, recolor)
        for dy, line in ipairs(sprite) do
            for dx = 1, #line do
                local key = line:sub(dx, dx)
                if key ~= "." and key ~= " " then
                    if type(recolor) == "table" then
                        key = recolor[key] or key
                    elseif recolor then
                        key = recolor
                    end
                    canvas.set(x + dx - 1, y + dy - 1, key)
                end
            end
        end
        return canvas
    end

    ---@return string[]
    function canvas.rows()
        local out = {}
        for y, row in ipairs(grid) do
            out[y] = table.concat(row)
        end
        return out
    end

    return canvas
end

--- A small seeded PRNG (Park–Miller) so procedural art never disturbs the
--- global `math.random` state other plugins may rely on.
---@param seed? integer
---@return fun(lo?: integer, hi?: integer): number
function M.rng(seed)
    local state = (seed or vim.uv.hrtime()) % 2147483646 + 1
    return function(lo, hi)
        state = state * 16807 % 2147483647
        local unit = (state - 1) / 2147483646
        if not lo then return unit end
        return lo + math.floor(unit * (hi - lo + 1))
    end
end

return M
