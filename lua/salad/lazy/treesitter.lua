-- treesitter.lua: Syntax highlighting and parser management

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      -- Minimal profile has no compiler; rely on the parsers bundled with
      -- Neovim and skip installing/compiling more.
      if not vim.g.salad_minimal then
        require("nvim-treesitter").install({
          "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
          "python", "javascript", "typescript",
          "c", "cpp", "rust", "go",
          "r", "rnoweb", "yaml", "csv", "latex",
        })
      end

      vim.treesitter.language.register("markdown", "quarto")

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.treesitter.highlighter.active[args.buf] then
            return
          end
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
        desc = "Treesitter highlighting when a parser is installed",
      })
    end,
  },
}
