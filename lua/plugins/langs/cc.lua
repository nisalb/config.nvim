local util = require("config.util")

local names = util.names

local function for_cc_files(spec)
  return util.fn.for_filetypes(spec, util.ft.cc)
end

return {
  -- add treesitters
  util.fn.ensure_treesitters({ "c", "cpp", "cmake", "make", "meson" }),

  {
    names.lspconfig,
    opts = {
      servers = {
        ccls = {
          init_options = {
            highlight = {
              lsRanges = true,
            },
          },
        },
      },
    },
  },

  {
    names.null_ls,
    opts = function(_, opts)
      local nls = require("null-ls")

      -- TODO: add clang_format to manual sync list
      table.insert(opts.sources, nls.builtins.formatting.clang_format)
    end,
  },

  for_cc_files({
    "jackguo380/vim-lsp-cxx-highlight",
  }),
}
