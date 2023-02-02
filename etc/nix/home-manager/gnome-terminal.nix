{
  programs.gnome-terminal = {
    enable = false;
    showMenubar = false;
    themeVariant = "dark";
    profile.vpenso = {
      default = true;
      showScrollbar = false;
      cursorShape = "block";
      cursorBlnkMode = "on";
    };
  };
}
