-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Swedish keyboard aliases: ö replaces [, ä replaces ]. Keep the original
-- mappings and resolve them recursively to retain counts and buffer-local actions.
local motion_modes = { "n", "x", "o" }
local bracket_pairs = {
    { "[b", "]b", "Previous buffer", "Next buffer" },
    { "[B", "]B", "First buffer", "Last buffer" },
    { "[t", "]t", "Previous tab", "Next tab" },
    { "[q", "]q", "Previous quickfix entry", "Next quickfix entry" },
    { "[Q", "]Q", "First quickfix entry", "Last quickfix entry" },
    { "[<C-Q>", "]<C-Q>", "Previous quickfix file", "Next quickfix file" },
    { "[l", "]l", "Previous location entry", "Next location entry" },
    { "[L", "]L", "First location entry", "Last location entry" },
    { "[<C-L>", "]<C-L>", "Previous location file", "Next location file" },
    { "[<C-T>", "]<C-T>", "Previous preview tag", "Next preview tag" },
    { "[d", "]d", "Previous diagnostic", "Next diagnostic" },
    { "[D", "]D", "First diagnostic", "Last diagnostic" },
    { "[e", "]e", "Previous error", "Next error" },
    { "[w", "]w", "Previous warning", "Next warning" },
    { "[y", "]y", "Previous symbol", "Next symbol" },
    { "[Y", "]Y", "Previous higher-level symbol", "Next higher-level symbol" },
    { "[r", "]r", "Previous reference", "Next reference" },
    { "[T", "]T", "Previous TODO comment", "Next TODO comment" },
    { "[g", "]g", "Previous Git hunk", "Next Git hunk" },
    { "[G", "]G", "First Git hunk", "Last Git hunk" },
    {
        "[k",
        "]k",
        "Previous block start",
        "Next block start",
        modes = motion_modes,
    },
    {
        "[K",
        "]K",
        "Previous block end",
        "Next block end",
        modes = motion_modes,
    },
    {
        "[f",
        "]f",
        "Previous function start",
        "Next function start",
        modes = motion_modes,
    },
    {
        "[F",
        "]F",
        "Previous function end",
        "Next function end",
        modes = motion_modes,
    },
    { "[a", "]a", "Previous argument", "Next argument", modes = motion_modes },
    {
        "[A",
        "]A",
        "Previous argument end or first file",
        "Next argument end or last file",
        modes = motion_modes,
    },
    { "[i", "]i", "Scope top", "Scope bottom", modes = motion_modes },
    {
        "[%",
        "]%",
        "Previous unmatched group",
        "Next unmatched group",
        modes = motion_modes,
    },
    {
        "[c",
        "]c",
        "Previous change or Neogit item",
        "Next change or Neogit item",
        modes = motion_modes,
    },
    {
        "[[",
        "]]",
        "Previous section or plugin item",
        "Next section or plugin item",
        modes = motion_modes,
    },
    {
        "[n",
        "]n",
        "Previous Treesitter node",
        "Next Treesitter node",
        modes = { "x" },
    },
    {
        "[N",
        "]N",
        "Previous sibling node",
        "Next sibling node",
        modes = { "x" },
    },
    { "[<Space>", "]<Space>", "Add empty line above", "Add empty line below" },
}
local bracket_mappings = {}
for _, pair in ipairs(bracket_pairs) do
    for _, mode in ipairs(pair.modes or { "n" }) do
        if not bracket_mappings[mode] then
            bracket_mappings[mode] = {
                ["ö"] = { desc = "Previous" },
                ["ä"] = { desc = "Next" },
            }
        end
        for direction = 1, 2 do
            local target = pair[direction]
            local alias = target:gsub("%[", "ö"):gsub("%]", "ä")
            bracket_mappings[mode][alias] = {
                target,
                remap = true,
                desc = pair[direction + 2],
            }
        end
    end
end

---@type LazySpec
return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        -- Configure core features of AstroNvim
        features = {
            large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
            diagnostics = { virtual_text = false, virtual_lines = false }, -- diagnostic settings on startup
        },
        -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
        diagnostics = {
            virtual_text = false,
            underline = true,
            virtual_lines = {
                --  Only show virtual line diagnostics for the current cursor line
                current_line = true,
            },
        },
        -- vim options can be configured here
        options = {
            opt = { -- vim.opt.<key>
                relativenumber = true, -- sets vim.opt.relativenumber
                number = true, -- sets vim.opt.number
                spell = false, -- sets vim.opt.spell
                signcolumn = "yes", -- sets vim.opt.signcolumn to yes
                wrap = false, -- sets vim.opt.wrap
                cmdheight = 0,
                showtabline = 0,
                showcmd = false,
            },
            g = { -- vim.g.<key>
                -- configure global vim variables (vim.g)
                -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
                -- This can be found in the `lua/lazy_setup.lua` file
            },
        },
        -- Mappings can be configured through AstroCore as well.
        -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
        mappings = {
            -- first key is the mode
            n = vim.tbl_extend("force", bracket_mappings.n, {
                ["<Leader>k"] = {
                    function()
                        local path = vim.fs.joinpath(
                            vim.fn.stdpath "config",
                            "CHEATSHEET.md"
                        )
                        vim.cmd.split(vim.fn.fnameescape(path))
                        vim.wo.wrap = true
                        vim.wo.linebreak = true
                    end,
                    desc = "Keymap cheat sheet",
                },

                ["<Leader>gg"] = {
                    "<Cmd>Neogit<CR>",
                    desc = "Open Neogit Tab Page",
                },

                ["<Leader>x"] = { desc = "󰈙 Scratch" },
                ["<Leader>xx"] = {
                    function() require("snacks").scratch() end,
                    desc = "Toggle Scratch Buffer",
                },
                ["<Leader>xs"] = {
                    function() require("snacks").scratch.select() end,
                    desc = "Select Scratch Buffer",
                },
            }),
            x = bracket_mappings.x,
            o = bracket_mappings.o,
        },
    },
}
