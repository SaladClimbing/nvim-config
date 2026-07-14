return {
    "williamboman/mason.nvim",
    opts = {},
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
        require("mason").setup(opts)

        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
                map("gr", require("telescope.builtin").lsp_references, "References")
                map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
                map("gy", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("gD", vim.lsp.buf.declaration, "Goto Declaration")
                map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("<leader>rn", vim.lsp.buf.rename, "Rename")
                map("<leader>e", vim.diagnostic.open_float, "Line Diagnostics")
                map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next Diagnostic")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                end
            end,
        })

        mason_lspconfig.setup({
            ensure_installed = {
                "pyright",
                "vtsls",
                "html",
                "cssls",
                "tailwindcss",
                "gopls",
                "rust_analyzer",
                "clangd",
                "jsonls",
            },
            handlers = {
                function(server_name)
                    if server_name == "lua_ls" then
                        return
                    end
                    lspconfig[server_name].setup({})
                end,
            },
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            group = vim.api.nvim_create_augroup("mason-install", { clear = true }),
            callback = function()
                local mason_registry = require("mason-registry")
                for _, pkg_name in ipairs({
                    "ruff",
                    "prettierd",
                    "stylua",
                    "clang-format",
                    "goimports",
                    "golangci-lint",
                    "markdownlint",
                    "jq",
                    "eslint_d",
                }) do
                    local pkg = mason_registry.get_package(pkg_name)
                    if not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end,
        })
    end,
}
