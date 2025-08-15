vim.loader.enable()

local utils = require("utils")

local expected_version = "0.11.0"
utils.is_compatible_version(expected_version)

local config_dir = vim.fn.stdpath("config")
---@cast config_dir string

-- some global settings
require("globals")
-- setting options in nvim
vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/options.vim"))
-- various autocommands
require("custom-autocmd")
-- all the user-defined mappings
require("mappings")
-- all the plugins installed and their configurations
vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/plugins.vim"))
-- colorscheme settings
require("colorschemes")

vim.cmd.colorscheme("gruvbox")

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})
--[[
vim.cmd([[
  augroup WilderSetup
  autocmd!
  autocmd VimEnter * call wilder#enable_cmdline_enter()
  autocmd VimEnter * silent! UpdateRemotePlugins
  augroup END
]]
vim.opt.mouse = 'a' --enable mouse


