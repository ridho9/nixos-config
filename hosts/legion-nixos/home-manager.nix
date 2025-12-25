{
  config,
  pkgs,
  lib,
  inputs,
  mySystem,
  ...
}:

{
  imports = [
    ../../modules/home/fish.nix
    ../../modules/home/wayland-common.nix
    ../../modules/home/bitwarden.nix
    ../../modules/home/neovim.nix

    ../../modules/home/lang/python3.nix
    ../../modules/home/lang/nix.nix
    ../../modules/home/lang/go.nix
    ../../modules/home/lang/js.nix
    ../../modules/home/lang/ocaml.nix

    ./homeModules/waybar/waybar.nix
  ]
  ++ lib.optional mySystem.hyprland.enable ./homeModules/hyprland.nix;

  home.username = "rid9";
  home.homeDirectory = "/home/rid9";
  home.stateVersion = "24.05";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.pnpm"
  ];

  home.sessionVariables = {
    UV_PYTHON = "/etc/profiles/per-user/rid9/bin/python3";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    vscode-fhs
    firefox-devedition
    brave
    discord

    fastfetch
    gh

    wayland-scanner
    mpv
    httpie
    slack
    devenv
    postgresql
    valkey

    hyperfine
    caddy
    google-cloud-sdk
    postman

    qbittorrent-enhanced

    scrcpy
    kdePackages.okular

    beekeeper-studio

    prismlauncher

    supabase-cli
    php
    dbeaver-bin
    git-filter-repo

    adw-gtk3
    adwaita-icon-theme

    winetricks
    wineWowPackages.waylandFull
    xarchiver

    protonplus
    code-cursor-fhs

    zed-editor-fhs

    dbus
    temporal-cli
    zellij

    jdk21
    seahorse

    obs-studio
    spotify
    yt-dlp

    ncdu
    dua
    mozjpeg
    optipng
    pngquant

    google-cloud-sql-proxy
    antigravity-fhs
  ];

  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };

  xdg.autostart.enable = true;

  programs.git = {
    enable = true;
    settings.user.name = "ridho9";
    settings.user.email = "p.ridho9@gmail.com";
    lfs.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common = {
      default = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome" ];
    };
    xdgOpenUsePortal = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "FiraCode Nerd Font";
      env.TERM = "xterm-256color";
      window.decorations = "none";
      font.size = 12;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      font-family = "FiraCode Nerd Font";
      font-size = 12;
    };
  };

  programs.rclone = {
    enable = true;
  };
}
