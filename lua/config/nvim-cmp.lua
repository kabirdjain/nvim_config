-- Setup nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")


vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#ff5252" })
vim.api.nvim_set_hl(0, "CmpItemKindLspSymbol", { fg = "#4ec9b0" })
vim.api.nvim_set_hl(0, "CmpItemKindBuffer", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "CmpItemKindPath", { fg = "#ffd700" })

cmp.setup {
  snippet = {
    expand = function(args)
      -- For `ultisnips` user.
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = cmp.mapping.close(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  },
  sources = {
    { name = "copilot" }, --Copilot
    { name = "nvim_lsp" }, -- For nvim-lsp
    { name = "ultisnips" }, -- For ultisnips user.
    { name = "path" }, -- for path completion
    { name = "buffer", keyword_length = 2 }, -- for buffer word completion
  },
  completion = {
    keyword_length = 1,
    completeopt = "menu,noselect",
  },
  view = {
    entries = "custom",
  },
  formatting = {
    format = lspkind.cmp_format {
      mode = "symbol",
      max_width = 50,
      symbol_map = {
        Copilot = "",
      },
      before = function(entry, vim_item)
        vim_item.kind_hl_group = "CmpItemKind" .. (vim_item.kind or entry.source.name)
        return vim_item
      end,
      menu = {
        nvim_lsp = "[LSP]",
        ultisnips = "[UltiSnips]",
        path = "[Path]",
        buffer = "[Buffer]",
        emoji = "[Emoji]",
        omni = "[Omni]",
        copilot = "[Copilot]",
      },
      show_labelDetails = true,
      maxwidth = 40,
      ellipsis_char = "...",
    },
  }, 
}

cmp.setup.filetype("tex", {
  sources = {
    { name = "omni" },
    { name = "ultisnips" }, -- For ultisnips user.
    { name = "buffer", keyword_length = 2 }, -- for buffer word completion
    { name = "path" }, -- for path completion
  },
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

--  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd([[
  highlight! link CmpItemMenu Comment
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])
