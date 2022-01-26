return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            IntelliSense = {
                traceBeSetted = true,
                traceFieldInject = true,
                traceLocalSet = true,
                traceReturn = true,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                },
            },
        },
    },
}
