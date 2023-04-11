local util = require("config.util")
local names = util.names

local function for_clojure_files(spec)
  return util.fn.for_filetypes(spec, util.ft.clojure)
end

-- plugins spec for clojure
return {

  -- add treesitter
  {
    names.treesitter,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "clojure" })
    end,
  },

  -- ensure clojure_lsp is installed.
  {
    names.mason,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "clojure-lsp" })
    end,
  },

  -- setup lsp server
  {
    names.lspconfig,
    opts = {
      clojure_lsp = {},
    },
  },

  -- setup null-ls formatting
  {
    names.null_ls,
    opts = function(_, opts)
      local nls = require("null-ls")

      -- zprint has to be manually inserted
      -- TODO: add zprint to manual sync list
      table.insert(opts.sources, nls.builtins.formatting.zprint)
    end,
  },

  for_clojure_files({ "tpope/vim-fireplace" }),
  for_clojure_files({ "tpope/vim-salve" }),
  for_clojure_files({ "guns/vim-clojure-static" }),
  for_clojure_files({
    "eraserhd/parinfer-rust",
    build = "cargo build --release",
  }),
  for_clojure_files({
    "Olical/conjure",
    keys = {
      { "<localleader>cc", ":ConjureConnect<CR>", mode = "n", desc = "Conjure Connect" },
    },
    config = function(_, _)
      require("which-key").register({
        ["<localleader>c"] = { name = "+conjure" },
      })
    end,
  }),
}
