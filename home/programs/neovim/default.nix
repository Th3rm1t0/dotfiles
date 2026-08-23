{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfiles.programs.neovim;

  nixPlugins = {
    inherit (pkgs.vimPlugins)
      lazy-nvim
      nvim-lspconfig
      blink-cmp
      conform-nvim
      nvim-lint
      gitsigns-nvim
      fzf-lua
      neo-tree-nvim
      trouble-nvim
      bufferline-nvim
      lualine-nvim
      which-key-nvim
      nvim-web-devicons
      tokyonight-nvim
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-nio
      neotest
      neotest-golang
      nvim-autopairs
      comment-nvim
      plenary-nvim
      ;
    nvim-treesitter = pkgs.symlinkJoin {
      name = "nvim-treesitter-with-grammars";
      paths = [
        pkgs.vimPlugins.nvim-treesitter
      ]
      ++ pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    };
  };

  nixPluginsLua = ''
    return {
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: pkg: ''["${name}"] = "${pkg}",'') nixPlugins
      )}
    }
  '';
in
{
  options.dotfiles.programs.neovim.enable = lib.mkEnableOption "neovim" // {
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        go
        gopls
        delve
        gofumpt
        gotools
        golangci-lint
        lua-language-server
        stylua
      ];
    };

    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua" = {
        source = ./lua;
        recursive = true;
      };
      "nvim/lua/nix_plugins.lua".text = nixPluginsLua;
      "nvim/after" = {
        source = ./after;
        recursive = true;
      };
    };
  };
}
