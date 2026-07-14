return {
  {
    "tpope/vim-fugitive",
    -- Since it's written in Vimscript, we load it on a custom event 
    -- or when you run a Git command to keep startup fast.
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff Split" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
    },
  }
}
