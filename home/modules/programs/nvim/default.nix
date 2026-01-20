_:
{ config, lib, ... }:

let
  cfg = config.programs.nixvim;
in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      opts = {
        belloff = "all";
        number = true;
        relativenumber = true;
        scrolloff = 10;
        showmode = false;
        signcolumn = "yes";
        cursorline = true;
        wrap = false;
        updatetime = 1000;
        hidden = true;
        # clipboard = "unnamedplus"

        mouse = "";

        incsearch = true;
        hlsearch = false;
        ignorecase = true;
        smartcase = true;

        # wildmode = "longest:full";
        # wildoptions = "pum";

        tabstop = 4;
        softabstop = 4;
        shiftwidth = 4;

        smartindent = true;
        expandtab = true;

        equalalways = false;
        splitright = true;
        splitbelow = true;

        pumblend = 17;

        # TODO
        # undodir =
        # undofile = true
        # swapfile = false
        # backup = false

        # TODO
        # vim.cmd [[
        #     au BufWinEnter * set formatoptions-=c formatoptions-=r formatoptions-=o
        #     au BufRead * set formatoptions-=c formatoptions-=r formatoptions-=o
        #     au BufNewFile * set formatoptions-=c formatoptions-=r formatoptions-=o
        # ]]
      };
      autoCmd = {
        event = [
          "BufRead"
          "BufNewFile"
        ];
        pattern = [
          "*.html"
          "*.md"
          "*.js"
          "*.ts"
          "*.svelte"
          "*.tsx"
          "*.css"
          "*.php"
          "*.json"
          "*.nix"
        ];
        command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2";
      };
      # TODO
      # vim.cmd [[
      # autocmd BufRead,BufNewFile *.php set autoindent
      # ]];
    };
  };
}
