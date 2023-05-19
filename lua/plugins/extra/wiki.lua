return {
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>T", ":Telekasten panel<CR>", desc = "Telekasten" },
    },
    opts = {
      home = vim.fn.expand("~/Notes"),
    },
  },
}
