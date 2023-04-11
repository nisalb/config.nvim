-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  -- { "folke/trouble.nvim", enabled = false },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end,
        desc = "Find Plugin File",
      },
    },
  },

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  -- add some treesitter parsers.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  -- add jsonls and schemastore ans setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- following the approach by lazyvim, I have modularized my language-specifuc configurations.
  { import = "plugins.langs.clojure" },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },

      -- this will set for all commands, even :w, which is not desirable
      -- TODO: find a fix for this.
      --
      -- messages = {
      --  view = "messages",
      -- },

      popupmenu = {
        backend = "cmp",
      },
    },
  },

  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
 ███████████             ███     ██████   ███               █████
░░███░░░░░███           ░░░     ███░░███ ░░░               ░░███ 
 ░███    ░███   ██████  ████   ░███ ░░░  ████   ██████   ███████ 
 ░██████████   ███░░███░░███  ███████   ░░███  ███░░███ ███░░███ 
 ░███░░░░░███ ░███████  ░███ ░░░███░     ░███ ░███████ ░███ ░███ 
 ░███    ░███ ░███░░░   ░███   ░███      ░███ ░███░░░  ░███ ░███ 
 █████   █████░░██████  █████  █████     █████░░██████ ░░████████
░░░░░   ░░░░░  ░░░░░░  ░░░░░  ░░░░░     ░░░░░  ░░░░░░   ░░░░░░░░

                "Learning requires inefficiency" 
                                       - Rich Hickey
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button(
          "c",
          " " .. " Config",
          "[[:lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') }) <cr>]]"
        ),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8

      return dashboard
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VimEnter",
    keys = {
      { "<leader>tt", ":ToggleTerm direction=horizontal<CR>", mode = "n", desc = "Open a horizontal(-) terminal" },
      { "<leader>tv", ":ToggleTerm direction=vertical<CR>", mode = "n", desc = "Open a vertical(|) terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.3
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local wk = require("which-key")
      wk.register({
        ["<leader>t"] = { name = "+terminals" },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
    },
    opts = {
      options = {
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 100,
        },
      },
      sections = {
        lualine_a = {
          { "fancy_mode", width = 3 },
        },
        lualine_b = {
          { "fancy_branch" },
          { "fancy_diff" },
        },
        lualine_c = {
          { "fancy_cwd", substitute_home = true },
        },
        lualine_x = {
          { "fancy_macro" },
          { "fancy_diagnostics" },
          { "fancy_searchcount" },
          { "fancy_location" },
        },
        lualine_y = {
          { "fancy_filetype", ts_icon = "" },
        },
        lualine_z = {
          { "fancy_lsp_servers" },
        },
      },
    },
  },
}
