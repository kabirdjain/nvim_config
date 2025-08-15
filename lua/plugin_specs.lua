local utils = require("utils")

local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_dir .. "/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {
  -- auto-completion engine
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    -- event = 'InsertEnter',
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-omni",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("config.nvim-cmp")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    enabled = function()
      if vim.g.is_mac then
        return true
      end
      return false
    end,
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } },

  { "machakann/vim-swap", event = "VeryLazy" },

  -- IDE for Lisp
  -- 'kovisoft/slimv'
  {
    "vlime/vlime",
    enabled = function()
      if utils.executable("sbcl") then
        return true
      end
      return false
    end,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
    end,
    ft = { "lisp" },
  },

  -- Super fast buffer jump
  {
    "smoka7/hop.nvim",
    event = "VeryLazy",
    config = function()
      require("config.nvim_hop")
    end,
  },

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },
  {
    "Yggdroot/LeaderF",
    cmd = "Leaderf",
    build = function()
      local leaderf_path = plugin_dir .. "/LeaderF"
      vim.opt.runtimepath:append(leaderf_path)
      vim.cmd("runtime! plugin/leaderf.vim")

      if not vim.g.is_win then
        vim.cmd("LeaderfInstallCExtension")
      end
    end,
  },
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
    },
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup {}
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    main = "render-markdown",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },
  -- plugins for coloring, set lazy = false if you want to use it
  { "navarasu/onedark.nvim", lazy = true },
  { "sainnhe/edge", lazy = true },
  { "sainnhe/sonokai", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true }, 
  { "shaunsingh/solarized.nvim", lazy = true},
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  { "rose-pine/neovim", lazy = true },
  { "hyperb1iss/silkcircuit-nvim" },
  {
    "rockyzhang24/arctic.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "arctic",
    branch = "v2",
  },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = firenvim_not_active,
    config = function()
      require("config.lualine")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = { "BufEnter" },
    cond = firenvim_not_active,
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen
  {
    "nvimdev/dashboard-nvim",
    cond = firenvim_not_active,
    config = function()
      require("config.dashboard-nvim")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    config = function()
      require("config.indent-blankline")
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    opts = {},
    config = function()
      require("config.nvim-statuscol")
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require("config.nvim_ufo")
    end,
  },
  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VeryLazy" },

  -- notification plugin
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      require("config.nvim-notify")
    end,
  },

  -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
  -- not be possible since we maybe in a server which disables GUI.
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      else
        return false
      end
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings
    submodules = false, -- not needed, submodules are required only for tests
  },

  -- Only install these plugins if ctags are installed on the system
  -- show file tags in vim window
  {
    "liuchengxu/vista.vim",
    enabled = function()
      if utils.executable("ctags") then
        return true
      else
        return false
      end
    end,
    cmd = "Vista",
  },

  -- Snippet engine and snippet template
  { "SirVer/ultisnips", dependencies = {
    "honza/vim-snippets",
  }, event = "InsertEnter" },

  -- Automatic insertion and deletion of a pair of characters
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comment plugin
  { "tpope/vim-commentary", event = "VeryLazy" },

  -- Multiple cursor plugin like Sublime Text?
  -- 'mg979/vim-visual-multi'

  -- Autosave files on certain events
  { "907th/vim-auto-save", event = "InsertEnter" },

  -- Show undo history visually
  { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },

  -- better UI for some nvim actions
  { "stevearc/dressing.nvim" },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
    event = "VeryLazy",
  },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } },

  -- Repeat vim motions
  { "tpope/vim-repeat", event = "VeryLazy" },

  { "nvim-zh/better-escape.vim", event = { "InsertEnter" } },

  {
    "lyokha/vim-xkbswitch",
    enabled = function()
      if vim.g.is_mac and utils.executable("xkbswitch") then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  {
    "Neur1n/neuims",
    enabled = function()
      if vim.g.is_win then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  -- Auto format tools
  { "sbdchd/neoformat", cmd = { "Neoformat" } },

  -- Git command inside vim
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = function()
      require("config.fugitive")
    end,
  },

  -- Better git log display
  { "rbong/vim-flog", cmd = { "Flog" } },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "ruifm/gitlinker.nvim",
    event = "User InGitRepo",
    config = function()
      require("config.git-linker")
    end,
  },

  -- Show git change (change, delete, add) signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  },

  {
    "sindrets/diffview.nvim",
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("config.bqf")
    end,
  },

  -- Another markdown plugin
  { "preservim/vim-markdown", ft = { "markdown" } },

  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular", cmd = { "Tabularize" } },

  -- Markdown previewing (only for Mac and Windows)
  {
    "iamcco/markdown-preview.nvim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      end
      return false
    end,
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  {
    "rhysd/vim-grammarous",
    enabled = function()
      if vim.g.is_mac then
        return true
      end
      return false
    end,
    ft = { "markdown" },
  },

  { "chrisbra/unicode.vim", event = "VeryLazy" },

  -- Additional powerful text object for vim, this plugin should be studied
  -- carefully to use its full power
  { "wellle/targets.vim", event = "VeryLazy" },

  -- Plugin to manipulate character pairs quickly
  { "machakann/vim-sandwich", event = "VeryLazy" },

  -- Add indent object for vim (useful for languages like Python)
  { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

  -- Only use these plugin on Windows and Mac and when LaTeX is installed
  {
    "lervag/vimtex",
    enabled = function()
      if utils.executable("latex") then
        return true
      end
      return false
    end,
    ft = { "tex" },
  },

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- .tmux.conf syntax highlighting and setting check
  {
    "tmux-plugins/vim-tmux",
    enabled = function()
      if utils.executable("tmux") then
        return true
      end
      return false
    end,
    ft = { "tmux" },
  },

  -- Modern matchit implementation
  { "andymass/vim-matchup", event = "BufRead" },
  { "tpope/vim-scriptease", cmd = { "Scriptnames", "Messages", "Verbose" } },

  -- Asynchronous command execution
  { "skywind3000/asyncrun.vim", lazy = true, cmd = { "AsyncRun" } },
  { "cespare/vim-toml", ft = { "toml" }, branch = "main" },

  -- Edit text area in browser using nvim
  {
    "glacambre/firenvim",
    enabled = function()
      local result = vim.g.is_win or vim.g.is_mac
      return result
    end,
    -- it seems that we can only call the firenvim function directly.
    -- Using vim.fn or vim.cmd to call this function will fail.
    build = function()
      local firenvim_path = plugin_dir .. "/firenvim"
      vim.opt.runtimepath:append(firenvim_path)
      vim.cmd("runtime! firenvim.vim")

      -- macOS will reset the PATH when firenvim starts a nvim process, causing the PATH variable to change unexpectedly.
      -- Here we are trying to get the correct PATH and use it for firenvim.
      -- See also https://github.com/glacambre/firenvim/blob/master/TROUBLESHOOTING.md#make-sure-firenvims-path-is-the-same-as-neovims
      local path_env = vim.env.PATH
      local prologue = string.format('export PATH="%s"', path_env)
      -- local prologue = "echo"
      local cmd_str = string.format(":call firenvim#install(0, '%s')", prologue)
      vim.cmd(cmd_str)
    end,
  },
  -- Debugger plugin
  {
    "sakhnik/nvim-gdb",
    enabled = function()
      if vim.g.is_win or vim.g.is_linux then
        return true
      end
      return false
    end,
    build = { "bash install.sh" },
    lazy = true,
  },

  -- Session management plugin
  { "tpope/vim-obsession", cmd = "Obsession" },

  {
    "ojroques/vim-oscyank",
    enabled = function()
      if vim.g.is_linux then
        return true
      end
      return false
    end,
    cmd = { "OSCYank", "OSCYankReg" },
  },

  --Don't need right now, maybe add later?
  {
    "gelguy/wilder.nvim",
    enabled = false,
    build = ":UpdateRemotePlugins",
  },
  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.which-key")
    end,
  },

  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },

  -- file explorer, TURNED OFF FOR NOW
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    tag = "legacy",
    config = function()
      require("config.fidget-nvim")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {},
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
  -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  -- copilot, remove it since autocomplete isn't good
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "smjonas/live-command.nvim",
    -- live-command supports semantic versioning via Git tags
    -- tag = "2.*",
    cmd = "Preview",
    config = function()
      require("config.live-command")
    end,
    event = "VeryLazy",
  },
  {
    -- show hint for code actions, the user can also implement code actions themselves,
    -- see discussion here: https://github.com/neovim/neovim/issues/14869
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup { autocmd = { enabled = true } }
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    opts = {
      rocks = { "lua-toml" }, -- specifies a list of rocks to install
      -- luarocks_build_args = { "--with-lua=/my/path" }, -- extra options to pass to luarocks's configuration script
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    "andweeb/presence.nvim",
    config = function()
      require("presence").setup({
        -- Optional configuration options for presence.nvim
        auto_update = true,
        neovim_image_text = "The Arch of IDEs",
        main_image = "neovim",
        log_level = "info",
        debounce_timeout = 10,
        enable_line_number = false,
        blacklist = {},
        buttons = true,
        file_assets = {},
        show_time = true,

        -- Rich Presence text options
        editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
        file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
        git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
        plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
        reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
        workspace_text      = "Working in %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
        line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
      })
    end,
  },
  {
  "m4xshen/smartcolumn.nvim",
  opts = {
    -- change this if assignment requires certain amount of characters per line
    colorcolumn = "0",
    disabled_filetypes =  {"NvimTree", "lazy", "mason", "help", "checkhealth", "lspinfo", "noice", "Trouble", "fish", "zsh", "dashboard"}
    }
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    'xeluxee/competitest.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
    config = function() 
      require('config.competitest')
    end,
  },
  -- INSANE PLUGIN (GOAT FOLKE)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      dim = { enabled = true },
      explorer = { enabled = true },
      image = { 
        enabled = true,
        doc = { 
          inline = false,
          float = true 
        }, 
      },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      zen = { enabled = true },
    },
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
    require('lspsaga').setup({})
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons',     -- optional
    }
  },
  -- folke messages and cmdline
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end
  },
  -- saves sessions on exit, basically tmux lite edition
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },
  -- helps manage windows in nvim
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {}
  },
  -- lsp lazy install
  {
    "mason-org/mason.nvim",
    config = function()
    require('mason').setup({})
    end,
  },
  -- rust add on
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "maan2003/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  },
}

require("lazy").setup {
  spec = plugin_specs,
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
}
