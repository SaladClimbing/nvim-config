-- conform.lua: Format on save

return {
    "stevearc/conform.nvim",
    opts = {
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_fix", "ruff_format" },
            javascript = { "prettierd" },
            typescript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescriptreact = { "prettierd" },
            html = { "prettierd" },
            css = { "prettierd" },
            json = { "prettierd" },
            markdown = { "prettierd" },
            go = { "goimports", "gofmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            rust = { "rustfmt" },
        },
    },
}
