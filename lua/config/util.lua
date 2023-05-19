local M = {}

M.names = require("config.names")

M.ft = {
  clojure = { "clojure", "edn" },
  cc = { "c", "cpp", "make", "cmake", "m4", "meson" },
}

M.fn = {}

function M.fn.for_filetypes(spec, fts)
  return vim.tbl_extend("force", spec, { ft = fts })
end

function M.fn.merge_lists(lists)
  local final = {}

  for _, lst in ipairs(lists) do
    vim.list_extend(final, lst)
  end

  return final
end

function M.fn.ensure_treesitters(names)
  return {
    M.names.treesitter,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, names)
    end,
  }
end

function M.fn.ensure_mason(names)
  return {
    M.names.mason,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, names)
    end,
  }
end

return M
