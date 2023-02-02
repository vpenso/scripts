{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.username = "vpenso";
  home.homeDirectory = "/home/vpenso";

  home.packages = [
    pkgs.git
    pkgs.zsh
    pkgs.tmux
    pkgs.neovim
    pkgs.ccrypt
    pkgs.wl-clipboard
    pkgs.gnome.gnome-terminal
  ];

  imports = [
    ./home-manager/gnome-terminal.nix
  ];

}
