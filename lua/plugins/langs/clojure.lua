local util = require("config.util")
local names = util.names

local function for_clojure_files(spec)
  return util.fn.for_filetypes(spec, util.ft.clojure)
end

-- plugins spec for clojure
return {

  -- add treesitter
  util.fn.ensure_treesitters({ "clojure" }),

  -- ensure clojure_lsp is installed.
  util.fn.ensure_mason({ "clojure-lsp" }),

  -- setup lsp server
  {
    names.lspconfig,
    opts = {
      servers = {
        clojure_lsp = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
      },
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
    -- Do not load conjure for filetypes. It is not useful that way.
    "Olical/conjure",
    keys = {
      { "<leader>cc", ":ConjureConnect<CR>", mode = "n", desc = "Conjure Connect" },
    },
    config = function(_, _)
      require("which-key").register({
        ["<leader>c"] = { name = "+clojure" },
      })
    end,
  }),
}
