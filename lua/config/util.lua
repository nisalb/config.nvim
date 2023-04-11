local M = {}

M.names = require("config.names")

M.ft = {
  clojure = { "clojure", "edn" },
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

return M
