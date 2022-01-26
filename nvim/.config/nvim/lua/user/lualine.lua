local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    -- symbols = { error = "", warn = "", info = "" },
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

local mode = {
    "mode",
    fmt = function(str)
        return string.sub(str, 1, 1)
    end,
}

local progress = {
    function()
        local current_line = vim.fn.line "."
        local total_lines = vim.fn.line "$"
        local chars = { "_", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
    end,
    padding = 0,
}

lualine.setup {
    options = {
        icons_enabled = true,
        theme = "tokyonight",
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "toggleterm" },
        always_divide_middle = true,
        component_separators = { left = " ", right = " " },
        section_separators = { left = "", right = "" },
    },
    sections = {
        -- lualine_a = {
        --     {
        --         "buffers",
        --         -- shows shortened relative path when false
        --         show_filename_only = true,
        --         -- shows indicator then buffer is modified
        --         show_modified_status = true,
        --         -- 0 shows buffer name
        --         -- 1 buffer index (bufnr)
        --         -- 2 shows buffer name + buffer index (bufnr)
        --         mode = 0,
        --         -- maximum width of buffers component
        --         -- can also be a function that returns value of max_length dynamicaly
        --         -- shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
        --         max_length = vim.o.columns * 2 / 3,
        --         filetype_names = {
        --             TelescopePrompt = "Telescope",
        --             dashboard = "Dashboard",
        --             packer = "Packer",
        --             fzf = "FZF",
        --             alpha = "Alpha",
        --         },
        --     },
        -- },
        lualine_a = { branch },
        lualine_b = { mode },
        lualine_c = { diagnostics },
        lualine_x = {},
        lualine_y = { "encoding" },
        lualine_z = { location, progress },
    },
    -- inactive_sections = {
    --     lualine_a = {},
    --     lualine_b = {},
    --     lualine_c = { "filename" },
    --     lualine_x = { "location" },
    --     lualine_y = {},
    --     lualine_z = {},
    -- },
    tabline = {},
    extensions = {},
}
