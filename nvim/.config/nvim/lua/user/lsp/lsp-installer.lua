local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end
local servers = {
    "bashls",
    "clangd",
    "gopls",
    "omnisharp",
    "sourcekit",
    "sumneko_lua",
    "tsserver",
    "html",
    "cssls",
    "cssmodules_ls",
}

local settings = {
    ensure_installed = servers,
    log_level = vim.log.levels.INFO,
}

lsp_installer.setup(settings)

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

for _, server in pairs(servers) do
    if server == "jsonls" then
        local jsonls_opts = require("user.lsp.settings.jsonls")
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end

    if server == "sumneko_lua" then
        local sumneko_opts = require("user.lsp.settings.sumneko_lua")
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end

    lspconfig[server].setup(opts)
end
