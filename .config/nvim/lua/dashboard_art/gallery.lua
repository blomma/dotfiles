-- Dashboard header artwork. See `dashboard_art/init.lua` for the block types
-- and the palette keys (r o y g t c b p m, their shadows in upper case, plus
-- w W L s d k).

local art = require "dashboard_art"

local M = {}

---@param text string
---@param width integer
local function center(text, width)
    local len = vim.fn.strdisplaywidth(text)
    local left = math.floor((width - len) / 2)
    return (" "):rep(left) .. text .. (" "):rep(width - len - left)
end

-- Neovim ---------------------------------------------------------------------

-- The mark, rasterised from its polygon geometry: two prisms joined by a
-- diagonal, each with a lit and a shaded face. The right prism is the left
-- one rotated by 180 degrees.
local NEOVIM_MARK = {
    "......t.............c......",
    ".....tt.............cc.....",
    "....ttt1............ccc....",
    "...gttt1............cccb...",
    "..ggttt11...........cccbb..",
    ".gggttt11...........cccbbb.",
    "ggggttt111..........cccbbbb",
    "ggggttt111..........cccbbbb",
    "ggggtttG111.........cccbbbb",
    "ggggtttG111.........cccbbbb",
    "ggggtttGG111........cccbbbb",
    "ggggtttGGG111.......cccbbbb",
    "ggggtttGGG111.......cccbbbb",
    "ggggtttGGGG111......cccbbbb",
    "ggggtttGGGG111......cccbbbb",
    "ggggtttGGGGG111.....cccbbbb",
    "ggggtttGGGGG111.....cccbbbb",
    "ggggtttGGGGGG111....cccbbbb",
    "ggggtttGGGGGG111....cccbbbb",
    "ggggtttGGGGGGG111...cccbbbb",
    "ggggtttGGGGGGG111...cccbbbb",
    ".gggttt.GGGGGGG111..cccbbb.",
    "..ggttt.GGGGGGG111..cccbb..",
    "...gttt..GGGGGGG111.cccb...",
    "....ttt..GGGGGGG111.ccc....",
    ".....tt...GGGGGGG111cc.....",
    "......t...GGGGGGG111c......",
}

M.neovim = {
    blocks = function(pal)
        local v = vim.version()
        local sky = art.canvas(41, 28)
        sky.stamp(NEOVIM_MARK, 7, 0)
        sky.set(1, 2, "s").set(38, 1, "W").set(3, 16, "W").set(39, 12, "s")
        sky.set(36, 24, "s").set(0, 25, "d").set(40, 20, "d")
        return {
            {
                "pixel",
                rows = sky.rows(),
                colors = { ["1"] = art.blend(pal.g, pal.G, 0.35) },
            },
            {
                "gradient",
                text = ("N E O V I M   v%d.%d.%d"):format(
                    v.major,
                    v.minor,
                    v.patch
                ),
                stops = { "g", "t", "c", "b" },
                bold = true,
            },
        }
    end,
}

-- Space Invaders ----------------------------------------------------------

local SQUID = {
    "...XX...",
    "..XXXX..",
    ".XXXXXX.",
    "XX.XX.XX",
    "XXXXXXXX",
    "..X..X..",
    ".X.XX.X.",
    "X.X..X.X",
}
local CRAB = {
    "..X.....X..",
    "...X...X...",
    "..XXXXXXX..",
    ".XX.XXX.XX.",
    "XXXXXXXXXXX",
    "X.XXXXXXX.X",
    "X.X.....X.X",
    "...XX.XX...",
}
local CANNON = {
    "......X......",
    ".....XXX.....",
    ".....XXX.....",
    ".XXXXXXXXXXX.",
    "XXXXXXXXXXXXX",
    "XXXXXXXXXXXXX",
    "XXXXXXXXXXXXX",
    "XXXXXXXXXXXXX",
}
local BOMB = { "X.", ".X", "X.", ".X" }

M.invaders = {
    blocks = function()
        local scene = art.canvas(48, 30)
        for i = 0, 3 do
            scene.stamp(SQUID, 4 + i * 12, 0, "p")
            scene.stamp(CRAB, 1 + i * 12, 10, "c")
        end
        scene.stamp(BOMB, 33, 18, "y")
        scene.stamp({ "X", "X" }, 21, 19, "W")
        scene.stamp(CANNON, 15, 22, "g")

        local score = "SCORE<1>  01337        HI-SCORE  09001"
        local mask = "wwwwwwww  ggggg        wwwwwwww  yyyyy"
        return {
            { "glyph", lines = { score }, fg = { mask }, bold = true },
            { "pixel", rows = scene.rows() },
        }
    end,
}

-- TARDIS -------------------------------------------------------------------

M.tardis = {
    blocks = function(pal)
        local colors = {
            l = art.blend(pal.y, pal.L, 0.55), -- lit window
            n = art.blend(pal.B, "#000000", 0.6), -- sign panel
        }

        local top = art.canvas(37, 6)
        top.stamp({
            "..........y..........",
            ".........yLy.........",
            ".........BbB.........",
            "....bbbbbbbbbbbbb....",
            "..BBBBBBBBBBBBBBBBB..",
            ".bbbbbbbbbbbbbbbbbbb.",
        }, 8, 0)
        top.set(2, 1, "s").set(31, 0, "W").set(35, 3, "s").set(5, 4, "W")

        local door = {
            "BBBBBBB",
            "BllBllB",
            "BllBllB",
            "BBBBBBB",
            "BllBllB",
            "BllBllB",
            "BBBBBBB",
            "bbbbbbb",
            "bBBBBBb",
            "bBBBBBb",
            "bbbbbbb",
            "bBBBBBb",
            "bBBBBBb",
            "bbbbbbb",
            "bBBBBBb",
            "bBBBBBb",
            "bbbbbbb",
        }
        local body = art.canvas(37, 20)
        for y = 0, 17 do
            body.stamp({ "Bb" }, 9, y).stamp({ "bB" }, 26, y).set(18, y, "B")
        end
        body.stamp({ ("b"):rep(19) }, 9, 0)
        body.stamp(door, 11, 1).stamp(door, 19, 1)
        body.stamp({ "LLLLL", "LLLLL" }, 12, 9) -- the phone notice
        body.stamp({ ("B"):rep(21), ("B"):rep(21) }, 8, 18)
        body.set(1, 3, "W").set(4, 13, "s").set(33, 6, "s").set(35, 15, "W")
        body.set(30, 11, "s").set(2, 18, "s")

        local sign = " POLICE    BOX "
        local line = "  ✦      " .. "  " .. sign .. "  " .. "       ·  "
        local fg = "  y      " .. "  " .. ("L"):rep(15) .. "  " .. "       s  "
        local bg = "         " .. "bb" .. ("n"):rep(15) .. "bb" .. "          "

        return {
            { "pixel", rows = top.rows(), colors = colors },
            {
                "glyph",
                lines = { line },
                fg = { fg },
                bg = { bg },
                colors = colors,
                bold = true,
            },
            { "pixel", rows = body.rows(), colors = colors },
            {
                "gradient",
                text = "TIME AND RELATIVE DIMENSION IN SPACE",
                stops = { "b", "p", "c" },
            },
        }
    end,
}

-- Commodore 64 boot screen -------------------------------------------------

M.c64 = {
    blocks = function(pal)
        local v = vim.version()
        local ok, lazy = pcall(require, "lazy")
        local stats = ok and lazy.stats() or { count = 0, loaded = 0 }
        local ram = math.floor(vim.uv.get_total_memory() / 1024 ^ 3 + 0.5)

        local text = art.blend(pal.b, pal.W, 0.3)
        local screen = art.blend(pal.b, pal._bg, 0.62)
        local border = art.blend(pal.b, pal._bg, 0.15)

        local inner = {
            "",
            center(
                ("**** NEOVIM %d.%d.%d BASIC V2 ****"):format(
                    v.major,
                    v.minor,
                    v.patch
                ),
                40
            ),
            "",
            (" %dG RAM SYSTEM  %d/%d PLUGINS LOADED"):format(
                ram,
                stats.loaded,
                stats.count
            ),
            "",
            "READY.",
            'LOAD"NEOVIM",8,1',
            "",
            "SEARCHING FOR NEOVIM",
            "LOADING",
            "READY.",
            "RUN",
        }

        local rows = {}
        local function border_row()
            local row = {}
            for x = 1, 44 do
                row[x] = { " ", bg = border }
            end
            rows[#rows + 1] = row
        end
        border_row()
        for i, s in ipairs(inner) do
            local row = { { " ", bg = border }, { " ", bg = border } }
            local cells = art.chars(s:upper())
            for x = 1, 40 do
                row[#row + 1] = { cells[x] or " ", fg = text, bg = screen }
            end
            if i == #inner then
                row[2 + #cells + 1] =
                    { "█", fg = text, bg = screen, blink = true }
            end
            row[#row + 1] = { " ", bg = border }
            row[#row + 1] = { " ", bg = border }
            rows[#rows + 1] = row
        end
        border_row()

        return {
            { "cells", rows = rows },
            {
                "gradient",
                text = "64K RAM  //  38911 BASIC BYTES FREE",
                stops = { "s", "b", "s" },
            },
        }
    end,
}

-- The Matrix ---------------------------------------------------------------

local GLYPHS =
    art.chars "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝ0123456789:=*+-<>¦"
local QUOTES = {
    "Wake up, Neo(vim)...",
    "The Matrix has you...",
    "Follow the white rabbit.",
    "Knock, knock, Neo.",
}

M.matrix = {
    blocks = function(pal)
        local random = art.rng()
        local width, height = 44, 13
        local head = art.blend(pal.g, pal.W, 0.7)
        local green = pal.g

        local rows = {}
        for y = 1, height do
            rows[y] = {}
            for x = 1, width do
                rows[y][x] = { " " }
            end
        end

        for x = 1, width do
            local drops = random() < 0.25 and 2 or (random() < 0.85 and 1 or 0)
            for _ = 1, drops do
                local length = random(4, 12)
                local tip = random(1, height + length)
                for y = math.max(1, tip - length + 1), math.min(height, tip) do
                    local age = (tip - y) / length
                    local glyph = GLYPHS[random(1, #GLYPHS)]
                    if y == tip then
                        rows[y][x] = { glyph, fg = head, bold = true }
                    else
                        rows[y][x] = {
                            glyph,
                            fg = art.blend(green, pal._bg, 0.15 + age * 0.7),
                        }
                    end
                end
            end
        end

        local quote = QUOTES[random(1, #QUOTES)]
        local y = math.floor(height / 2) + 1
        local text = art.chars("  " .. quote .. "█  ")
        local left = math.floor((width - #text) / 2)
        for i, ch in ipairs(text) do
            rows[y][left + i] = {
                ch,
                fg = pal.W,
                bold = true,
                blink = ch == "█" or nil,
            }
        end
        for i = 1, #text do
            rows[y - 1][left + i] = { " " }
            rows[y + 1][left + i] = { " " }
        end

        return {
            { "cells", rows = rows },
            {
                "gradient",
                text = "THERE IS NO SPOON  //  THERE IS ONLY :wq",
                stops = { "G", "g", "G" },
            },
        }
    end,
}

-- Pixel remakes of the original headers -----------------------------------

-- Top view, flying right: dish and quad-gun turret on the disc, cockpit on
-- the starboard side, docking slot between the mandibles, engines glowing
-- along the rear arc.
local FALCON = {
    "...............+++..........................",
    ".-.........+++++++++++......................",
    ".........+++++++-+++++++..................W.",
    "........++++++++-++++++==...................",
    ".......c++++++++-+++++L===..........d.......",
    ".....Ccc++++++++++++=LLL===.................",
    "....CcL++++++--+++--LLdLL===................",
    "....CL+++rr--++++===-LLL=++++++++++.........",
    "...CcL--++r+++++======L=============........",
    "...CL++++-++++=========-=====rrr=====.......",
    "..CcL++++-+++==========-=d============......",
    "..CcL+++-++=============-==============.....",
    "..CcL+++-+=====ddd======-==d................",
    "..CcL+++-=====ddLdd=====-==d................",
    "..CcL++=-=====ddLdd=====-==d..............d.",
    "..CcL+==-======ddd======---d................",
    "..CcL===d===============-==============.....",
    "..CcL====-=============--=============......",
    "...CL====-===========----=======rr===.......",
    "...CcL--==-=========-----===========........",
    "....CL=====--=====---d-------------.........",
    "....CcL=====dd-==-----------................",
    ".....Ccc=======------========.+++...........",
    ".......c======-------========++++c..........",
    "........====---------============c..........",
    ".........==------------------====c.....-....",
    "..d........-----------------..===...........",
    "...............---..........................",
}

M.falcon_hd = {
    blocks = {
        { "pixel", rows = FALCON },
        {
            "gradient",
            text = "MILLENNIUM FALCON  //  .5 PAST LIGHTSPEED",
            stops = { "-", "+", "c" },
            bold = true,
        },
    },
}

-- Constitution class in profile: saucer with bridge and sensor domes, swept
-- neck, engineering hull with a glowing deflector dish, and a nacelle with
-- its red bussard collector, passing a planet.
local ENTERPRISE = {
    "................................................",
    ".W.................d..........-.................",
    "................................................",
    "...........LLrL.........rrrLLLLLLLLLLLLLLLLLLLd.",
    "..........LLLLLL........rro+++++++++++++++++++d.",
    "..LLLLLLLLLLLLLLLLLLLLLLrro+++++++++++++++++++d.",
    "++++y++y++y++y++y++y++y+++r-------------------d.",
    "..++++++++++++++++++++++..............---.......",
    "...........---..++++..................--........",
    "...........---....++++...............--.........",
    "...................++++.............---.........",
    ".....................++++..........---..........",
    "......d...............++++.........--...........",
    "........................++++......--............",
    ".........................+++++...---............",
    "....................oooLLLLLLLLLLLLLLLLLLLLLLL..",
    "....................oLLo+++y++y++y++y++y++y+dd..",
    "....................oLo+++++++++++++++++++++dd..",
    "........................-----------------.......",
    "................................................",
    "................................................",
    "................................................",
    "................................................",
    "Pmmmmmmmmm............W.........................",
    "PPPPpppppmm.................................-...",
    "PPPPPppppppmm...................................",
    "PPPPPPPpppppm........................d..........",
    "PPPPPPPPpppppm..................................",
}

M.enterprise_hd = {
    blocks = {
        { "pixel", rows = ENTERPRISE },
        {
            "gradient",
            text = "U.S.S. ENTERPRISE  //  NCC-1701",
            stops = { "b", "y", "r" },
            bold = true,
        },
    },
}

-- Hook & Ladder 8: brick and stone facade, Slimer haunting a window, the
-- NO GHOST sign on its bracket and Ecto-1 waiting in the arched bay.
local FIREHOUSE_UPPER = {
    "...++++++++++++++++++++++++++++++++++++++...",
    "...======================================...",
    "....dRRdRRdRRdRRdRRdRRdRRdRRdRRdRRdRRdRR....",
    "....RRR====RRRR====RRRRRR====RRRR====RRR....",
    "....RRRyyyyRRRRBBBBRRRRRRBBBBRRRRyyyyRRR....",
    "....RRRyyyyRRRRBBBBRRRRRRBBBBRRRRyyyyRRR....",
    "....RRR++++RRRR++++RRRRRR++++RRRR++++RRR....",
    "....====================================....",
    "....RRR====RRRR====RRRRRR====RRRR====RRR....",
    "....RRRBBBBRRRRyyyyRRRRRRLgLBRRRRBBBBRRR....",
    "....RRRBBBBRRRRyyyyRRRRRRgGgBRRRRBBBBRRR....",
    "....RRR++++RRRR++++RRRRRR++++RRRR++++RRR....",
}
local FIREHOUSE_GROUND = {
    "....===RRRRRRRR=====dddd=====RRRRRRRR===....",
    ".y..===RRRRRR==dddddddddddddd==RRRRRddddd...",
    "yyy.===RRRRR=dddddddddddddddddd=RRRRrrrrr...",
    ".d..===RRRR=dddddddddddddddddddd=RrrLLLLLrr.",
    ".d..===RRRR=ddddddrcrWWrcrdddddd=RrrLLLLLLr.",
    ".d..===RRRRRddddd==========dddddRrLLrLLLLLLr",
    ".d..===RRRRRddddd=BBBBBBBB=dddddRrLdLrdLLLLr",
    ".d..===RRRRRddddLBBBBBBBBBBLddddRrLLLLrLLLLr",
    ".d..===RRRRRdddLLLLLLLLLLLLLLdddRrLLLLLrLLLr",
    ".d..===RRRRRdddLyyLddddddLyyLdddRrLLLLLLrLLr",
    ".d..===RRRRRdddLLLLrrrrrrLLLLdddRRrLLLLLLrr.",
    ".d..===RRRRRddd==============dddRRrrLLLLLrr.",
    ".d..ddddddddddddddddddddddddddddddddddddr...",
    "============================================",
}

M.firehouse_hd = {
    blocks = function()
        -- the carved name band between the floors, flanked by the pilasters
        local name = "HOOK & LADDER 8"
        local band = 30
        local left = math.floor((band - #name) / 2)
        local text = (" "):rep(4 + 3 + left)
            .. name
            .. (" "):rep(band - #name - left + 3 + 4)
        local bg = "    ===" .. ("R"):rep(band) .. "===    "
        return {
            { "pixel", rows = FIREHOUSE_UPPER },
            {
                "glyph",
                lines = { text },
                bg = { bg },
                default = "L",
                bold = true,
            },
            { "pixel", rows = FIREHOUSE_GROUND },
            {
                "gradient",
                text = "14 N MOORE ST  //  WHO YA GONNA CALL?",
                stops = { "r", "W", "g" },
                bold = true,
            },
        }
    end,
}

-- Ports of the original single-colour headers -------------------------------

M.falcon = {
    -- Adapted from the top-view artwork signed "LS" at:
    -- https://the.sunnyspot.org/asciiart/gallery/starwars.html
    blocks = {
        {
            "glyph",
            align = "left",
            lines = {
                "✦          ▄     ▄",
                "          ╱█│   │█╲",
                "         ╱ █│   │█ ╲",
                "        ╱  █│▄▄▄│█  ╲    ▄",
                "       ╱    │   │    ╲  ╱█╲",
                "      ╱ ╭───│   │───╮ ╲╱   │",
                "     ╱╭─╯ ▄▄│   │▄▄ ╰─╮    │",
                "    ╱ ╱    ╲│   │╱    ╲  ╱─╯",
                "   │       ╰───╯      │╱",
                "   ╰───╮____╱  ◉  ╲____╭───╯",
                "    ▓▓▓▓▓▓▓│     │▓▓▓▓▓▓▓",
                "    ╭───~~~~╲     ╱~~~~───╮",
                "     ╲      ╱╲───╱╲      ╱",
                "      ╰──╯         ╰──╯",
            },
            fg = {
                "y",
                "",
                "",
                "             sss",
                "",
                "",
                "          oo       oo",
                "",
                "",
                "",
                "",
                "        bbbb       bbbb",
            },
            default = "s",
            charmap = {
                ["▄█"] = "w",
                ["◉"] = "y",
                ["▓"] = "c",
                ["~"] = "b",
                ["_"] = "d",
            },
            defaults = { [5] = "w", [6] = "w", [7] = "w", [8] = "w" },
        },
        {
            "gradient",
            text = "MILLENNIUM FALCON  //  YT-1300",
            stops = { "s", "W", "c" },
            bold = true,
        },
    },
}

M.enterprise = {
    -- Redrawn from the Constitution-class front view at:
    -- https://sunnyspot.org/asciiart/gallery/startrek.html
    blocks = {
        {
            "glyph",
            lines = {
                "·      ╭──╮                       ╭──╮      ✦",
                "│  │        __───__        │  │",
                "__╰──╯_____───_______───_____╰──╯__",
                "╲_________________________________╱",
                "╲╲_   ╲_______╱   _╱╱",
                "╲╲_   ╲___╱   _╱╱",
                "╲╲__─│ │─__╱╱",
                "╲╱ ╭───╮ ╲╱",
                "│ ◉ │",
                "╰───╯",
            },
            fg = {
                "s      rrrr                       rrrr      y",
                "rrrr        WWWWWWW        rrrr",
                "wwrrrrwwwwwwwwwwwwwwwwwwwwwwwrrrrww",
            },
            default = "s",
            charmap = { ["◉"] = "o" },
            defaults = { [4] = "w", [8] = "w", [9] = "w", [10] = "w" },
        },
        {
            "gradient",
            text = "U.S.S. ENTERPRISE  //  NCC-1701",
            stops = { "b", "y", "r" },
            bold = true,
        },
    },
}

local function firehouse_floor(text)
    local len = vim.fn.strdisplaywidth(text)
    local left = math.floor((38 - len) / 2)
    return "║"
        .. (" "):rep(left)
        .. text
        .. (" "):rep(38 - len - left)
        .. "║"
end
local FIREHOUSE_BORDER = ("═"):rep(38)

M.firehouse = {
    blocks = {
        {
            "glyph",
            lines = {
                "╔" .. FIREHOUSE_BORDER .. "╗",
                firehouse_floor "░▒░  G H O S T B U S T E R S  ░▒░",
                "╠" .. FIREHOUSE_BORDER .. "╣",
                firehouse_floor "╭────╮    ╭────╮    ╭────╮",
                firehouse_floor "│ ▐▐ │    │ ▐▐ │    │ ▐▐ │",
                firehouse_floor "╰────╯    ╰────╯    ╰────╯",
                "╠" .. FIREHOUSE_BORDER .. "╣",
                firehouse_floor "╭────╮  ╔══════════════╗  ╭────╮",
                firehouse_floor "│ ▐▐ │  ║   ⊘ GHOST    ║  │ ▐▐ │",
                firehouse_floor "╰────╯  ║ ┌──────────┐ ║  ╰────╯",
                firehouse_floor "║ │ ECTO-1   │ ║",
                firehouse_floor "║ ╰──────────╯ ║",
                "╚" .. FIREHOUSE_BORDER .. "╝",
            },
            default = "W",
            charmap = {
                ["╔╗╚╝╠╣═║"] = "r",
                ["╭╮╰╯─│┌┐└┘"] = "s",
                ["▐"] = "y",
                ["░▒"] = "R",
                ["⊘"] = "r",
            },
        },
        {
            "gradient",
            text = "HOOK & LADDER 8  //  NYC",
            stops = { "r", "W", "r" },
            bold = true,
        },
    },
}

M.astro = {
    blocks = {
        {
            "glyph",
            lines = {
                "✦          ·          ✧",
                "▄████▄",
                "▄▄████████▄▄",
                "▄████████████████▄",
                "████  ████████  ████",
                "▀██████████████████▀",
                "▀▀███▀▀▀▀███▀▀",
                "▀  ▀▀  ▀",
                "░▒▓▓▒░",
            },
            fg = {
                "y          s          c",
                "cccccc",
                "pppppppppppp",
                "pppppppppppppppppp",
                "PPPPyyPPPPPPPPyyPPPP",
                "PPPPPPPPPPPPPPPPPPPP",
                "pppppppppppppp",
                "y  yy  y",
                "dsWWsd",
            },
        },
        {
            "gradient",
            text = "A S T R O  //  N V I M",
            stops = { "c", "p", "m" },
            bold = true,
        },
    },
}

M.order = {
    "neovim",
    "invaders",
    "tardis",
    "c64",
    "matrix",
    "falcon_hd",
    "falcon",
    "enterprise_hd",
    "enterprise",
    "firehouse_hd",
    "firehouse",
    "astro",
}
M.pieces = {}
for _, name in ipairs(M.order) do
    M.pieces[name] = M[name]
end

return M
