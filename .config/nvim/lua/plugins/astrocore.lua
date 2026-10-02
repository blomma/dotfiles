-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

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
            n = {
                -- Swedish keyboard navigation: ö for previous, ä for next.
                -- https://docs.astronvim.com/mappings/
                -- Remap to retain counts and buffer-local plugin mappings.
                ["ö"] = { desc = "Previous" },
                ["ä"] = { desc = "Next" },
                ["öt"] = { "[t", remap = true, desc = "Previous tab" },
                ["ät"] = { "]t", remap = true, desc = "Next tab" },
                ["öb"] = { "[b", remap = true, desc = "Previous buffer" },
                ["äb"] = { "]b", remap = true, desc = "Next buffer" },
                ["öq"] = {
                    "[q",
                    remap = true,
                    desc = "Previous quickfix entry",
                },
                ["äq"] = { "]q", remap = true, desc = "Next quickfix entry" },
                ["öQ"] = { "[Q", remap = true, desc = "First quickfix entry" },
                ["äQ"] = { "]Q", remap = true, desc = "Last quickfix entry" },
                ["öl"] = {
                    "[l",
                    remap = true,
                    desc = "Previous location entry",
                },
                ["äl"] = { "]l", remap = true, desc = "Next location entry" },
                ["öL"] = { "[L", remap = true, desc = "First location entry" },
                ["äL"] = { "]L", remap = true, desc = "Last location entry" },
                ["öd"] = { "[d", remap = true, desc = "Previous diagnostic" },
                ["äd"] = { "]d", remap = true, desc = "Next diagnostic" },
                ["öe"] = { "[e", remap = true, desc = "Previous error" },
                ["äe"] = { "]e", remap = true, desc = "Next error" },
                ["öw"] = { "[w", remap = true, desc = "Previous warning" },
                ["äw"] = { "]w", remap = true, desc = "Next warning" },
                ["öy"] = { "[y", remap = true, desc = "Previous symbol" },
                ["äy"] = { "]y", remap = true, desc = "Next symbol" },

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
            },
        },
    },
}
