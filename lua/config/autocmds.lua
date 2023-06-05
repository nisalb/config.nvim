-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local util = require("config.util")

-- helper for creating au groups
local function augroup(name)
  return vim.api.nvim_create_augroup("reified_" .. name, { clear = true })
end

-- set conjure localleader for relevant filetypes.
-- Whenever a new language support is required, add those
-- filetypes here, so that <localleader> is available
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("set_conjure_localleader"),
  pattern = util.fn.merge_lists({ util.ft.clojure }),
  callback = function()
    vim.g.maplocalleader = ","
  end,
})

-- unregister ' and ` from mini.pairs for some filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("unmap_quote_and_syntax_quote"),
  pattern = util.fn.merge_lists({ util.ft.clojure }),
  callback = function()
    vim.cmd([[
      inoremap <buffer> ' '
      inoremap <buffer> ` `
    ]])
  end,
})
