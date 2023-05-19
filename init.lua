-- bootstrap lazy.nvim, LazyVim and your plugins
vim.cmd([[
  set background=light
]])

if vim.g.vscode then
  require("vscode")
else
  require("config.lazy")
end
