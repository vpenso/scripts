{ config, pkgs, ... }:

{
  home.username = "vpenso";
  home.homeDirectory = "/home/vpenso";
  home.packages = [
    pkgs.git
    pkgs.zsh
    pkgs.tmux
    pkgs.neovim
    pkgs.ccrypt
    pkgs.wl-clipboard
  ];

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
}
