local o = vim.o
local wo = vim.wo
local bo = vim.bo
local g = vim.g

wo.number = true
wo.relativenumber = true

bo.expandtab = true
bo.shiftwidth = 2
bo.tabstop = 2

g["prettier#autoformat"] = 1
g["prettier#autoformat_require_pragma"] = 0
g["prettier#exec_cmd_async"] = 1
