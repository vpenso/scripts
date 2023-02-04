{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.username = "vpenso";
  home.homeDirectory = "/home/vpenso";

  home.packages = [
    pkgs.ccrypt
    pkgs.git
    pkgs.gnome.gnome-terminal
    pkgs.neovim
    pkgs.pandoc
    pkgs.tmux
    pkgs.wl-clipboard
    pkgs.zsh
  ];

  imports = [
    ./home-manager/gnome-terminal.nix
  ];

}
