{ config, pkgs, ... }: {
  home.packages = [ pkgs.zsh ];

  home.file = {
    ".zshrc".source = ./.zshrc;
  };
}
