{ pkgs, ... }:
{
  # ── Vim Options ──────────────────────────────────────────────────────────────
  opts = {
    number = true;
    clipboard = "unnamedplus";

    # Folding (required for nvim-ufo)
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };

  globals = {
    mapleader = " ";
    maplocalleader = "\\";
  };

  # ── Keymaps ──────────────────────────────────────────────────────────────────
  keymaps = [
    # ; -> : in normal mode
    { mode = "n"; key = ";"; action = ":"; }

    # \ -> NvimTreeFocus
    { mode = "n"; key = "\\"; action = "<cmd>NvimTreeFocus<CR>"; }

    # ── Splits ──
    { mode = "n"; key = "<leader>v"; action = "<cmd>vsplit<CR>"; options.desc = "Create vertical split"; }
    { mode = "n"; key = "<leader>h"; action = "<cmd>split<CR>"; options.desc = "Create horizontal split"; }

    # Split resizing
    { mode = "n"; key = "<C-Left>"; action = "<cmd>vertical resize -2<CR>"; options.desc = "Decrease width"; }
    { mode = "n"; key = "<C-Right>"; action = "<cmd>vertical resize +2<CR>"; options.desc = "Increase width"; }
    { mode = "n"; key = "<C-Up>"; action = "<cmd>resize -2<CR>"; options.desc = "Decrease height"; }
    { mode = "n"; key = "<C-Down>"; action = "<cmd>resize +2<CR>"; options.desc = "Increase height"; }

    # Equal size splits
    { mode = "n"; key = "<leader>="; action = "<C-w>="; options.desc = "Make splits equal size"; }

    # ── which-key ──
    {
      mode = "n";
      key = "<leader>?";
      action.__raw = ''function() require("which-key").show({ global = false }) end'';
      options.desc = "Buffer Local Keymaps (which-key)";
    }

    # ── lazygit ──
    { mode = "n"; key = "<leader>gg"; action = "<cmd>LazyGit<CR>"; options.desc = "LazyGit"; }

    # ── Telescope ──
    { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options.desc = "Find files"; }
    { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; options.desc = "Live grep"; }
    { mode = "n"; key = "<leader>fw"; action = "<cmd>Telescope grep_string<CR>"; options.desc = "Grep word under cursor"; }
    { mode = "n"; key = "<leader>gc"; action = "<cmd>Telescope git_status<CR>"; options.desc = "Git changed files"; }

    # ── Trouble ──
    { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.desc = "Diagnostics (Trouble)"; }
    { mode = "n"; key = "<leader>xX"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>"; options.desc = "Buffer Diagnostics (Trouble)"; }
    { mode = "n"; key = "<leader>cs"; action = "<cmd>Trouble symbols toggle focus=false<CR>"; options.desc = "Symbols (Trouble)"; }
    { mode = "n"; key = "<leader>cl"; action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>"; options.desc = "LSP Definitions / references / ... (Trouble)"; }
    { mode = "n"; key = "<leader>xL"; action = "<cmd>Trouble loclist toggle<CR>"; options.desc = "Location List (Trouble)"; }
    { mode = "n"; key = "<leader>xQ"; action = "<cmd>Trouble qflist toggle<CR>"; options.desc = "Quickfix List (Trouble)"; }

    # ── tmux-navigator ──
    { mode = "n"; key = "<C-h>"; action = "<cmd>TmuxNavigateLeft<CR>"; options.desc = "Move to left split/pane"; }
    { mode = "n"; key = "<C-j>"; action = "<cmd>TmuxNavigateDown<CR>"; options.desc = "Move to split/pane below"; }
    { mode = "n"; key = "<C-k>"; action = "<cmd>TmuxNavigateUp<CR>"; options.desc = "Move to split/pane above"; }
    { mode = "n"; key = "<C-l>"; action = "<cmd>TmuxNavigateRight<CR>"; options.desc = "Move to right split/pane"; }

    # ── Flash ──
    {
      mode = [ "n" "x" "o" ];
      key = "s";
      action.__raw = ''function() require("flash").jump() end'';
      options.desc = "Flash";
    }
    {
      mode = [ "n" "x" "o" ];
      key = "S";
      action.__raw = ''function() require("flash").treesitter() end'';
      options.desc = "Flash Treesitter";
    }
    {
      mode = "o";
      key = "r";
      action.__raw = ''function() require("flash").remote() end'';
      options.desc = "Remote Flash";
    }
    {
      mode = [ "n" "o" "x" ];
      key = "R";
      action.__raw = ''function() require("flash").treesitter_search() end'';
      options.desc = "Treesitter Search";
    }
    {
      mode = "c";
      key = "<C-s>";
      action.__raw = ''function() require("flash").toggle() end'';
      options.desc = "Toggle Flash Search";
    }

    # ── nvim-ufo ──
    {
      mode = "n";
      key = "zR";
      action.__raw = ''function() require("ufo").openAllFolds() end'';
      options.desc = "Open all folds";
    }
    {
      mode = "n";
      key = "zM";
      action.__raw = ''function() require("ufo").closeAllFolds() end'';
      options.desc = "Close all folds";
    }
    {
      mode = "n";
      key = "zK";
      action.__raw = ''function() require("ufo").peekFoldedLinesUnderCursor() end'';
      options.desc = "Peek fold";
    }

    # ── nvim-tree git filter ──
    {
      mode = "n";
      key = "<leader>gf";
      action.__raw = ''
        function()
          local api = require("nvim-tree.api")
          api.tree.open()
          api.tree.toggle_git_clean_filter()
        end
      '';
      options.desc = "Tree: toggle git changed files only";
    }
  ];

  # ── Autocommands ─────────────────────────────────────────────────────────────
  autoGroups.UserLspConfig = { clear = true; };

  autoCmd = [
    {
      event = "LspAttach";
      group = "UserLspConfig";
      callback.__raw = ''
        function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end
      '';
    }
  ];

  # ── Colorscheme ──────────────────────────────────────────────────────────────
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      transparent_background = true;
      flavour = "mocha";
    };
  };

  # ── Plugins ──────────────────────────────────────────────────────────────────
  plugins = {

    # ── UI ──
    which-key.enable = true;

    noice.enable = true;

    notify = {
      enable = true;
      settings.background_colour = "#000000";
    };

    web-devicons.enable = true;

    # ── File tree ──
    nvim-tree = {
      enable = true;
      settings.git.enable = true;
    };

    # ── Telescope ──
    telescope.enable = true;

    # ── Git ──
    lazygit.enable = true;

    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = { text = "│"; };
          change = { text = "│"; };
          delete = { text = "_"; };
          topdelete = { text = "‾"; };
          changedelete = { text = "~"; };
          untracked = { text = "┆"; };
        };
        signs_staged = {
          add = { text = "│"; };
          change = { text = "│"; };
          delete = { text = "_"; };
          topdelete = { text = "‾"; };
          changedelete = { text = "~"; };
        };
        current_line_blame = false;
        on_attach.__raw = ''
          function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            map("n", "]c", function()
              if vim.wo.diff then return "]c" end
              vim.schedule(function() gs.next_hunk() end)
              return "<Ignore>"
            end, { expr = true, desc = "Next git hunk" })

            map("n", "[c", function()
              if vim.wo.diff then return "[c" end
              vim.schedule(function() gs.prev_hunk() end)
              return "<Ignore>"
            end, { expr = true, desc = "Previous git hunk" })

            map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
            map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
            map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
            map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
            map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
            map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
            map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
            map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
            map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
            map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
            map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
            map("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff this ~" })

            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
          end
        '';
      };
    };

    # ── Treesitter ──
    treesitter = {
      enable = true;
      settings = {
        auto_install = true;
        highlight.enable = true;
      };
    };

    # ── LSP ──
    lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        gopls.enable = true;
        tinymist.enable = true;
        ts_ls.enable = true;
      };
    };

    # ── Completion ──
    cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "buffer"; }
        ];
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        mapping.__raw = ''
          cmp.mapping.preset.insert({
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            ['<C-j>'] = cmp.mapping.select_next_item(),
            ['<C-k>'] = cmp.mapping.select_prev_item(),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          })
        '';
      };
    };
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    luasnip.enable = true;

    # ── Editing ──
    nvim-autopairs.enable = true;
    flash.enable = true;

    nvim-ufo = {
      enable = true;
      settings.provider_selector.__raw = ''
        function()
          return { "treesitter", "indent" }
        end
      '';
    };

    # ── Formatting ──
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          python = [ "black" ];
          clojure = [ "zprint" ];
        };
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
      };
    };

    # ── Diagnostics ──
    trouble.enable = true;

    # ── Markdown ──
    render-markdown = {
      enable = true;
      settings.file_types = [ "markdown" "codecompanion" ];
    };

    # ── tmux integration ──
    tmux-navigator.enable = true;
  };

  extraPackages = with pkgs; [
    stylua
    black
    lazygit
  ];
}
