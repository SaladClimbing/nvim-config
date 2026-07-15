-- treesitter.lua: Syntax highlighting and parser management

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query", "markdown",
          "python", "javascript", "typescript",
          "c", "cpp", "rust", "go",
        },
        auto_install = true,
        highlight = { enable = true },
      })
    end,
  },
}
