local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local icons = require("user.icons")
local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    -- sections = { "error", "warn", "info", "hint" },
    sections = { "error", "warn" },
    symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
    colored = true,
    update_in_insert = false,
    always_visible = false,
}

local filetype = {
    "filetype",
    icons_enabled = false,
    separator = nil,
}

local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
}

local location = {
    "location",
    padding = 0,
}

local diff = {
    "diff",
    colored = false,
    symbols = { added = icons.git.Add .. " ", modified = icons.git.Mod .. " ", removed = icons.git.Remove .. " " }, -- changes diff symbols
    cond = hide_in_width,
}

local mode = {
    "mode",
    fmt = function(str)
        return string.sub(str, 1, 1)
    end,
}

-- local progress = {
--     function()
--         local current_line = vim.fn.line(".")
--         local total_lines = vim.fn.line("$")
--         local chars = { "_", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
--         local line_ratio = current_line / total_lines
--         local index = math.ceil(line_ratio * #chars)
--         return chars[index]
--     end,
--     padding = 0,
-- }
--
-- TODO: find out what is overriding this
vim.opt.laststatus = 3

lualine.setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        -- disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "toggleterm" },
        disabled_filetypes = { "alpha", "dashboard", "toggleterm" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { branch },
        lualine_b = { mode },
        lualine_c = { diagnostics },
        -- lualine_x = {},
        lualine_x = { diff, "encoding", filetype },
        lualine_y = {},
        lualine_z = { location },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {},
})
