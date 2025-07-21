-- ============================================================================
-- PLUGIN MANAGEMENT
-- ============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Mason for LSP/tool management
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          "ts_ls",
          "omnisharp",
          "powershell_es"
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
          end,

          -- Custom handler for lua_ls
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = { enable = false },
                },
              },
            })
          end,

          -- Custom handler for TypeScript
          ["ts_ls"] = function()
            require("lspconfig").ts_ls.setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = 'literal',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                }
              }
            })
          end,
        }
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          file_ignore_patterns = {
            "node_modules/.*",
            "%.git/.*",
            "%.DS_Store",
            "target/.*",
            "build/.*",
            "dist/.*"
          },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return {"--hidden"}
            end
          },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "javascript", "typescript", "tsx", "json",
          "html", "css", "bash", "python", "c_sharp",
          "markdown", "markdown_inline"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- Neotest for testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Nsidorenco/neotest-vstest",
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vstest"),
          require("neotest-vitest"),
        },
        output = {
          enabled = true,
          open_on_run = "short",
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        icons = {
          running = "🔄",
          passed = "✓",
          failed = "✗",
          skipped = "⏭",
        },
      })
    end,
  },

  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          telescope = true,
          treesitter = true,
          mason = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
        },
      })
    end,
  },

  -- Lualine statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            {
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = { error = "✗ ", warn = "⚠ ", info = "ℹ ", hint = "💡 " },
            },
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = false,
              path = 1,
            },
          },
          lualine_x = {
            {
              "filetype",
              colored = true,
              icon_only = false,
            },
            "encoding",
            "fileformat",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "mason", "lazy" },
      })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk)
          map('n', '<leader>hr', gs.reset_hunk)
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end,
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      -- Custom accept mapping
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })

      -- Navigation through suggestions
      vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
      vim.keymap.set("i", "<C-K>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-H>", "<Plug>(copilot-previous)")
    end,
  },

  -- Highlighted yank
  {
    "machakann/vim-highlightedyank",
    config = function()
      vim.g.highlightedyank_highlight_duration = 200
    end,
  },

  -- nvim-cmp completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
          keyword_length = 1,
        },
        window = {
          completion = {
            border = "none",
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
            scrollbar = false,
          },
          documentation = {
            border = "none",
            winhighlight = "Normal:CmpDocNormal",
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
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
        }),
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            trigger_characters = { ".", ":", "(", '"', "'", "/", "@", "*" }
          },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
        }, {
          { name = "buffer" },
        })
      })

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })
    end,
  },
}

-- Setup lazy.nvim
require("lazy").setup(plugins, {
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

-- Key mappings
vim.g.mapleader = " "                              -- Set leader key to space
vim.g.maplocalleader = " "                         -- Set local leader key

-- theme & transparency
vim.cmd.colorscheme("catppuccin")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- nvim-cmp transparent styling
vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpDocBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#313244" }) -- Subtle selection highlight for visibility

-- Basic settings
vim.opt.number = true                              -- Line numbers
vim.opt.relativenumber = false                      -- Relative line numbers
vim.opt.cursorline = true                          -- Highlight current line
vim.opt.wrap = false                               -- Don't wrap lines
vim.opt.scrolloff = 10                             -- Keep 10 lines above/below cursor 
vim.opt.sidescrolloff = 8                          -- Keep 8 columns left/right of cursor

-- Indentation
vim.opt.tabstop = 2                                -- Tab width
vim.opt.shiftwidth = 2                             -- Indent width
vim.opt.softtabstop = 2                            -- Soft tab stop
vim.opt.expandtab = true                           -- Use spaces instead of tabs
vim.opt.smartindent = true                         -- Smart auto-indenting
vim.opt.autoindent = true                          -- Copy indent from current line

-- Search settings
vim.opt.ignorecase = true                          -- Case insensitive search
vim.opt.smartcase = true                           -- Case sensitive if uppercase in search
vim.opt.hlsearch = false                           -- Don't highlight search results 
vim.opt.incsearch = true                           -- Show matches as you type

-- Visual settings
vim.opt.termguicolors = true                       -- Enable 24-bit colors
vim.opt.signcolumn = "yes"                         -- Always show sign column
vim.opt.colorcolumn = "180"                        -- Show column at 100 characters
vim.opt.showmatch = true                           -- Highlight matching brackets
vim.opt.matchtime = 2                              -- How long to show matching bracket
vim.opt.cmdheight = 1                              -- Command line height
vim.opt.completeopt = "menu,menuone,noselect"  -- Better completion options 
vim.opt.showmode = false                           -- Don't show mode in command line 
vim.opt.pumheight = 10                             -- Popup menu height 
vim.opt.pumblend = 10                              -- Popup menu transparency 
vim.opt.winblend = 0                               -- Floating window transparency 
vim.opt.conceallevel = 0                           -- Don't hide markup 
vim.opt.concealcursor = ""                         -- Don't hide cursor line markup 
vim.opt.lazyredraw = true                          -- Don't redraw during macros
vim.opt.synmaxcol = 300                            -- Syntax highlighting limit 

-- File handling
vim.opt.backup = false                             -- Don't create backup files
vim.opt.writebackup = false                        -- Don't create backup before writing
vim.opt.swapfile = false                           -- Don't create swap files
vim.opt.undofile = true                            -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")  -- Undo directory
vim.opt.updatetime = 300                           -- Faster completion
vim.opt.timeoutlen = 1000                          -- Key timeout duration
vim.opt.ttimeoutlen = 0                            -- Key code timeout
vim.opt.autoread = true                            -- Auto reload files changed outside vim
vim.opt.autowrite = false                          -- Don't auto save

-- Behavior settings
vim.opt.hidden = true                              -- Allow hidden buffers
vim.opt.errorbells = false                         -- No error bells
vim.opt.backspace = "indent,eol,start"             -- Better backspace behavior
vim.opt.autochdir = false                          -- Don't auto change directory
vim.opt.iskeyword:append("-")                      -- Treat dash as part of word
vim.opt.path:append("**")                          -- include subdirectories in search
vim.opt.selection = "exclusive"                    -- Selection behavior
vim.opt.mouse = "a"                                -- Enable mouse support
vim.opt.clipboard:append("unnamedplus")            -- Use system clipboard
vim.opt.modifiable = true                          -- Allow buffer modifications
vim.opt.encoding = "UTF-8"                         -- Set encoding

-- Cursor settings
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding settings
vim.opt.foldmethod = "expr"                             -- Use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"   -- Use treesitter for folding
vim.opt.foldlevel = 99                                  -- Start with all folds open

-- Split behavior
vim.opt.splitbelow = true                          -- Horizontal splits go below
vim.opt.splitright = true                          -- Vertical splits go right


-- Normal mode mappings
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Telescope keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })

-- Neotest keymaps
vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run test file" })
vim.keymap.set("n", "<leader>ts", function() require("neotest").run.run(vim.fn.getcwd()) end, { desc = "Run test suite" })
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "Open test output" })
vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, { desc = "Toggle test output panel" })
vim.keymap.set("n", "<leader>tS", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>tw", function() require("neotest").watch.toggle() end, { desc = "Toggle test watch mode" })

-- Keep file explorer for directory browsing
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Quick config editing
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

-- ============================================================================
-- HOTKEY CHEATSHEET
-- ============================================================================

local cheatsheet_state = {
  buf = nil,
  win = nil,
  is_open = false
}

local function show_cheatsheet()
  -- If cheatsheet is already open, close it
  if cheatsheet_state.is_open and vim.api.nvim_win_is_valid(cheatsheet_state.win) then
    vim.api.nvim_win_close(cheatsheet_state.win, false)
    cheatsheet_state.is_open = false
    return
  end

  -- Create the cheatsheet content
  local cheatsheet_content = {
    "═══════════════════════════════════════════════════════════════════════════════",
    "                              HOTKEY CHEATSHEET",
    "═══════════════════════════════════════════════════════════════════════════════",
    "",
    "🗂️  NAVIGATION & FILES",
    "   <leader>e          Open file explorer",
    "   <leader>ff         Find files (Telescope)",
    "   <leader>fg         Live grep (Telescope)",
    "   <leader>fb         Find buffers (Telescope)",
    "   <leader>fr         Recent files (Telescope)",
    "   <leader>fh         Help tags (Telescope)",
    "   <leader>fs         Find string under cursor",
    "   <leader>rc         Edit config",
    "",
    "🔍 SEARCH & MOVEMENT",
    "   <leader>c          Clear search highlights",
    "   n / N              Next/Previous search (centered)",
    "   <C-d> / <C-u>      Half page down/up (centered)",
    "",
    "📝 EDITING",
    "   <leader>d          Delete without yanking",
    "   J                  Join lines (keep cursor position)",
    "   <A-j> / <A-k>      Move line down/up",
    "   < / >              Indent left/right (visual mode)",
    "",
    "🪟 WINDOWS & SPLITS",
    "   <C-h/j/k/l>        Navigate windows",
    "   <leader>sv/sh      Split vertically/horizontally",
    "   <C-arrows>         Resize windows",
    "",
    "📋 BUFFERS & TABS",
    "   <leader>bn/bp      Next/Previous buffer",
    "   <leader>bd         Smart close buffer/tab",
    "   <leader>tn         New tab",
    "   <leader>tx         Close tab",
    "",
    "🖥️  TERMINAL",
    "   <leader>tt         Toggle floating terminal",
    "",
    "🔧 LSP (when available)",
    "   gD                 Go to definition",
    "   gr                 Go to references",
    "   K                  Show hover info",
    "   <leader>ca         Code actions",
    "   <leader>rn         Rename symbol",
    "   <leader>nd/pd      Next/Previous diagnostic",
    "   <C-Space>          Trigger completion (insert mode)",
    "   <Tab>/<S-Tab>      Navigate completion menu",
    "   <CR>               Confirm completion",
    "",
    "🧪 TESTING (Neotest)",
    "   <leader>tr         Run nearest test",
    "   <leader>tf         Run test file",
    "   <leader>ts         Run test suite",
    "   <leader>to         Open test output",
    "   <leader>tO         Toggle test output panel",
    "   <leader>tS         Toggle test summary",
    "   <leader>tw         Toggle test watch mode",
    "   <leader>fm         Format file",
    "",
    "🤖 COPILOT",
    "   <C-J>              Accept suggestion",
    "   <C-L>              Accept word",
    "   <C-K>              Next suggestion",
    "   <C-H>              Previous suggestion",
    "",
    "🔧 GIT (Gitsigns)",
    "   ]c / [c            Next/Previous hunk",
    "   <leader>hs         Stage hunk",
    "   <leader>hr         Reset hunk",
    "   <leader>hS         Stage buffer",
    "   <leader>hu         Undo stage hunk",
    "   <leader>hR         Reset buffer",
    "   <leader>hp         Preview hunk",
    "   <leader>hb         Show blame line",
    "   <leader>tb         Toggle line blame",
    "   <leader>hd         Diff this",
    "   <leader>td         Toggle deleted",
    "",
    "❓ HELP",
    "   <leader>cc         Show this cheatsheet",
    "",
    "═══════════════════════════════════════════════════════════════════════════════",
    "                        Press <Esc> or <leader>cc to close",
    "═══════════════════════════════════════════════════════════════════════════════"
  }

  -- Create buffer if it doesn't exist or is invalid
  if not cheatsheet_state.buf or not vim.api.nvim_buf_is_valid(cheatsheet_state.buf) then
    cheatsheet_state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(cheatsheet_state.buf, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(cheatsheet_state.buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(cheatsheet_state.buf, 'readonly', true)
  end

  -- Set the content
  vim.api.nvim_buf_set_option(cheatsheet_state.buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(cheatsheet_state.buf, 0, -1, false, cheatsheet_content)
  vim.api.nvim_buf_set_option(cheatsheet_state.buf, 'modifiable', false)

  -- Calculate window dimensions (make it large but not full screen)
  local width = math.min(85, math.floor(vim.o.columns * 0.9))
  local height = math.min(#cheatsheet_content + 2, math.floor(vim.o.lines * 0.9))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  cheatsheet_state.win = vim.api.nvim_open_win(cheatsheet_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set window options
  vim.api.nvim_win_set_option(cheatsheet_state.win, 'winblend', 0)
  vim.api.nvim_win_set_option(cheatsheet_state.win, 'winhighlight',
    'Normal:FloatingCheatNormal,FloatBorder:FloatingCheatBorder')

  -- Define highlight groups
  vim.api.nvim_set_hl(0, "FloatingCheatNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingCheatBorder", { bg = "none" })

  cheatsheet_state.is_open = true

  -- Set up keymaps to close the cheatsheet
  local close_opts = { buffer = cheatsheet_state.buf, nowait = true, silent = true }
  vim.keymap.set("n", "<Esc>", function()
    if cheatsheet_state.is_open and vim.api.nvim_win_is_valid(cheatsheet_state.win) then
      vim.api.nvim_win_close(cheatsheet_state.win, false)
      cheatsheet_state.is_open = false
    end
  end, close_opts)

  vim.keymap.set("n", "<leader>cc", function()
    if cheatsheet_state.is_open and vim.api.nvim_win_is_valid(cheatsheet_state.win) then
      vim.api.nvim_win_close(cheatsheet_state.win, false)
      cheatsheet_state.is_open = false
    end
  end, close_opts)

  -- Auto-close on buffer leave
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = cheatsheet_state.buf,
    callback = function()
      if cheatsheet_state.is_open and vim.api.nvim_win_is_valid(cheatsheet_state.win) then
        vim.api.nvim_win_close(cheatsheet_state.win, false)
        cheatsheet_state.is_open = false
      end
    end,
    once = true
  })
end

-- Keymap to show cheatsheet
vim.keymap.set("n", "<leader>cc", show_cheatsheet, { desc = "Show hotkey cheatsheet" })


-- Create autocmd group
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "lua", "python", "cs" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "javascript", "typescript", "json", "html", "css" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})


-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })


-- Better diff options
-- vim.opt.diffopt:append("linematch:60")

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================

-- terminal
local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
}

local function FloatingTerminal()
  -- If terminal is already open, close it (toggle behavior)
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return
  end

  -- Create buffer if it doesn't exist or is invalid
  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)
    -- Set buffer options for better terminal experience
    vim.api.nvim_buf_set_option(terminal_state.buf, 'bufhidden', 'hide')
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set transparency for the floating window
  vim.api.nvim_win_set_option(terminal_state.win, 'winblend', 0)

  -- Set transparent background for the window
  vim.api.nvim_win_set_option(terminal_state.win, 'winhighlight',
    'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder')

  -- Define highlight groups for transparency
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })

  -- Start terminal if not already running
  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end

  if not has_terminal then
    local shell = os.getenv("SHELL")
    if not shell and vim.fn.has("win32") == 1 then
      -- Try PowerShell Core first, then fallback to PowerShell 5
      if vim.fn.executable("pwsh") == 1 then
        shell = "pwsh"
      elseif vim.fn.executable("powershell") == 1 then
        shell = "powershell"
      else
        shell = "cmd.exe"
      end
    elseif not shell then
      shell = "/bin/sh"
    end
    vim.fn.termopen(shell)
  end

  terminal_state.is_open = true
  vim.cmd("startinsert")

  -- Set up auto-close on buffer leave 
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    callback = function()
      if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
      end
    end,
    once = true
  })
end

-- Key mappings
vim.keymap.set("n", "<leader>tt", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<leader>tt", function()
  if terminal_state.is_open then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })


-- ============================================================================
-- TABS
-- ============================================================================

-- Tab display settings
vim.opt.showtabline = 1  -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
vim.opt.tabline = ''     -- Use default tabline (empty string uses built-in)

-- Transparent tabline appearance
vim.cmd([[
  hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE
]])

-- Alternative navigation (more intuitive)
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })

-- Tab moving
vim.keymap.set('n', '<leader>tm', ':tabmove<CR>', { desc = 'Move tab' })
vim.keymap.set('n', '<leader>t>', ':tabmove +1<CR>', { desc = 'Move tab right' })
vim.keymap.set('n', '<leader>t<', ':tabmove -1<CR>', { desc = 'Move tab left' })

-- Function to open file in new tab
local function open_file_in_tab()
  vim.ui.input({ prompt = 'File to open in new tab: ', completion = 'file' }, function(input)
    if input and input ~= '' then
      vim.cmd('tabnew ' .. input)
    end
  end)
end

-- Function to duplicate current tab
local function duplicate_tab()
  local current_file = vim.fn.expand('%:p')
  if current_file ~= '' then
    vim.cmd('tabnew ' .. current_file)
  else
    vim.cmd('tabnew')
  end
end

-- Function to close tabs to the right
local function close_tabs_right()
  local current_tab = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr('$')

  for i = last_tab, current_tab + 1, -1 do
    vim.cmd(i .. 'tabclose')
  end
end

-- Function to close tabs to the left
local function close_tabs_left()
  local current_tab = vim.fn.tabpagenr()

  for i = current_tab - 1, 1, -1 do
    vim.cmd('1tabclose')
  end
end

-- Enhanced keybindings
vim.keymap.set('n', '<leader>to', open_file_in_tab, { desc = 'Open file in new tab' })
vim.keymap.set('n', '<leader>td', duplicate_tab, { desc = 'Duplicate current tab' })
vim.keymap.set('n', '<leader>tr', close_tabs_right, { desc = 'Close tabs to the right' })
vim.keymap.set('n', '<leader>tL', close_tabs_left, { desc = 'Close tabs to the left' })

-- Function to close buffer but keep tab if it's the only buffer in tab
local function smart_close_buffer()
  local buffers_in_tab = #vim.fn.tabpagebuflist()
  if buffers_in_tab > 1 then
    vim.cmd('bdelete')
  else
    -- If it's the only buffer in tab, close the tab
    vim.cmd('tabclose')
  end
end
vim.keymap.set('n', '<leader>bd', smart_close_buffer, { desc = 'Smart close buffer/tab' })



-- Define test signs
vim.fn.sign_define("test_pass", { text = "✓", texthl = "DiffAdd" })
vim.fn.sign_define("test_fail", { text = "✗", texthl = "DiffDelete" })

-- Ensure sign column is always visible
vim.opt.signcolumn = "yes"



-- formatting
local function format_code()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype

  -- Save cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  if filetype == 'sh' or filetype == 'bash' or filename:match('%.sh$') then
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, '\n')

    local cmd = {'shfmt', '-i', '2', '-ci', '-sr'}  -- 2 spaces, case indent, space redirects
    local result = vim.fn.system(cmd, content)

    if vim.v.shell_error == 0 then
      local formatted_lines = vim.split(result, '\n')
      if formatted_lines[#formatted_lines] == '' then
        table.remove(formatted_lines)
      end
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)
      vim.api.nvim_win_set_cursor(0, cursor_pos)
      print("Shell script formatted with shfmt")
      return
    else
      print("shfmt error: " .. result)
      return
    end
  end

  -- JavaScript/TypeScript formatting with prettier
  if filetype == 'javascript' or filetype == 'typescript' or
     filetype == 'javascriptreact' or filetype == 'typescriptreact' or
     filename:match('%.js$') or filename:match('%.ts$') or
     filename:match('%.jsx$') or filename:match('%.tsx$') then

    if vim.fn.executable('prettier') == 1 then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local content = table.concat(lines, '\n')

      local parser = 'babel'
      if filetype == 'typescript' or filename:match('%.ts$') then
        parser = 'typescript'
      elseif filetype == 'typescriptreact' or filename:match('%.tsx$') then
        parser = 'typescript'
      end

      local cmd = {'prettier', '--parser', parser, '--stdin-filepath', filename}
      local result = vim.fn.system(cmd, content)

      if vim.v.shell_error == 0 then
        local formatted_lines = vim.split(result, '\n')
        if formatted_lines[#formatted_lines] == '' then
          table.remove(formatted_lines)
        end
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        print("JS/TS formatted with prettier")
        return
      else
        print("prettier error: " .. result)
        return
      end
    else
      print("prettier not found. Install with: npm install -g prettier")
      return
    end
  end

  -- C# formatting with dotnet format
  if filetype == 'cs' or filename:match('%.cs$') or filename:match('%.csproj$') or filename:match('%.sln$') then
    if vim.fn.executable('dotnet') == 1 then
      local cmd

      if filename:match('%.sln$') then
        -- For solution files, format the entire solution
        cmd = {'dotnet', 'format', filename}
      elseif filename:match('%.csproj$') then
        -- For project files, format the entire project
        cmd = {'dotnet', 'format', filename}
      else
        -- For .cs files, format just the file by specifying the workspace explicitly
        local dir = vim.fn.expand('%:p:h')
        local sln_files = vim.fn.glob(dir .. '/*.sln', false, true)
        local csproj_files = vim.fn.glob(dir .. '/**/*.csproj', false, true)

        if #sln_files > 0 then
          -- Use solution file as workspace
          cmd = {'dotnet', 'format', sln_files[1], '--include', filename}
        elseif #csproj_files > 0 then
          -- Use project file as workspace  
          cmd = {'dotnet', 'format', csproj_files[1], '--include', filename}
        else
          -- No workspace found, try formatting without workspace
          cmd = {'dotnet', 'format', '--include', filename}
        end
      end

      local result = vim.fn.system(cmd)

      if vim.v.shell_error == 0 then
        -- Reload the buffer to show formatted content
        vim.cmd('edit!')
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        print("C# formatted with dotnet format")
        return
      else
        print("dotnet format error: " .. result)
        return
      end
    else
      print("dotnet CLI not found. Please install .NET SDK")
      return
    end
  end

  -- PowerShell formatting with PSScriptAnalyzer
  if filetype == 'ps1' or filetype == 'powershell' or filename:match('%.ps1$') or filename:match('%.psm1$') then
    if vim.fn.executable('pwsh') == 1 or vim.fn.executable('powershell') == 1 then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local content = table.concat(lines, '\n')

      local ps_exe = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'
      local format_cmd = string.format(
        '%s -NoProfile -Command "try { $content = @\'\n%s\n\'@; Invoke-Formatter -ScriptDefinition $content } catch { Write-Error $_.Exception.Message; exit 1 }"',
        ps_exe, content:gsub("'", "''")
      )

      local result = vim.fn.system(format_cmd)

      if vim.v.shell_error == 0 then
        local formatted_lines = vim.split(result, '\n')
        -- Remove trailing empty line if present
        if formatted_lines[#formatted_lines] == '' then
          table.remove(formatted_lines)
        end
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        print("PowerShell formatted with Invoke-Formatter")
        return
      else
        print("PowerShell formatter error: " .. result)
        print("Note: Install PSScriptAnalyzer module: Install-Module -Name PSScriptAnalyzer")
        return
      end
    else
      print("PowerShell not found. Please install PowerShell Core (pwsh) or Windows PowerShell")
      return
    end
  end

  print("No formatter available for " .. filetype)
end

vim.api.nvim_create_user_command("FormatCode", format_code, {
  desc = "Format current file"
})

vim.keymap.set('n', '<leader>fm', format_code, { desc = 'Format file' })

-- LSP keymaps setup
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = {buffer = event.buf}

    -- Navigation
    vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- Information
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- Code actions
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    -- Diagnostics
    vim.keymap.set('n', '<leader>nd', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>pd', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  end,
})

-- Better LSP UI
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.INFO] = "ℹ",
      [vim.diagnostic.severity.HINT] = "💡",
    }
  }
})

vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    print("No LSP clients attached to current buffer")
  else
    for _, client in ipairs(clients) do
      print("LSP: " .. client.name .. " (ID: " .. client.id .. ")")
    end
  end
end, { desc = 'Show LSP client info' })


