-- vim options
vim.opt.wrap = true -- display lines as one long line
vim.opt.number = false -- set numbered lines
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 2 spaces for a tabvim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation

vim.g.VimMailDontUseComplete = 1
vim.g.VimMailDoNotFold = 1

-- general
lvim.format_on_save.enabled = true
lvim.use_icons = true

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

lvim.builtin.which_key.mappings["t"] = {
    name = "Diagnostics",
    t = { "<cmd>TroubleToggle<cr>", "trouble" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
    r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")

-- Change theme settings
lvim.colorscheme = "catppuccin-frappe"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
-- lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
-- lvim.builtin.gitsigns.active = false
lvim.builtin.lualine.options.section_separators = {
    left = lvim.icons.ui.BoldDividerRight,
    right = lvim.icons.ui.BoldDividerLeft,
}

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "csharp_ls" })

-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--     return server ~= "omnisharp"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

---@diagnostic disable-next-line: unused-local
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--     if client.name == "omnisharp" then
--         -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
--         local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
--         for i, v in ipairs(tokenModifiers) do
--             local tmp = string.gsub(v, " ", "_")
--             tokenModifiers[i] = string.gsub(tmp, "-_", "")
--         end
--         local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
--         for i, v in ipairs(tokenTypes) do
--             local tmp = string.gsub(v, " ", "_")
--             tokenTypes[i] = string.gsub(tmp, "-_", "")
--         end
--     end
-- end

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        command = "prettier",
    },
    {
        command = "csharpier",
    },
    {
        command = "stylua",
    },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
    {
        name = "eslint",
    },
    {
        name = "gitsigns",
    },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    { name = "eslint" },
}

lvim.plugins = {
    {
        "sontungexpt/witch",
        priority = 1000,
        lazy = false,
        config = function(_, opts)
            require("witch").setup(opts)
        end,
    },
    {
        "folke/trouble.nvim",
        cmd = "TroubleToggle",
    },
    {
        "ellisonleao/gruvbox.nvim",
    },
    {
        "Mofiqul/dracula.nvim",
    },
    {
        "marko-cerovac/material.nvim",
    },
    {
        "rebelot/kanagawa.nvim",
    },
    {
        "EdenEast/nightfox.nvim",
    },
    {
        url = "https://gitlab.com/dbeniamine/vim-mail",
    },
    {
        "khaveesh/vim-fish-syntax",
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    {
        "folke/twilight.nvim",
    },
    {
        "folke/zen-mode.nvim",
    },
    {
        "fladson/vim-kitty",
    },
    {
        "renerocksai/telekasten.nvim",
        config = function()
            require("telekasten").setup {
                home = vim.fn.expand "~/zettelkasten",
            }
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "nvim-telescope/telescope.nvim", -- optional
            "sindrets/diffview.nvim", -- optional
        },
        config = true,
    },
    {
        "cameron-wags/rainbow_csv.nvim",
        config = true,
        ft = {
            "csv",
            "tsv",
            "csv_semicolon",
            "csv_whitespace",
            "csv_pipe",
            "rfc_csv",
            "rfc_semicolon",
        },
        cmd = {
            "RainbowDelim",
            "RainbowDelimSimple",
            "RainbowDelimQuoted",
            "RainbowMultiDelim",
        },
    },
}
