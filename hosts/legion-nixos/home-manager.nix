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

    spotify
    spotify
    yt-dlp

    ncdu
    dua
    mozjpeg
    optipng
    pngquant

    google-cloud-sql-proxy
    antigravity-fhs

    awscli2
    terraform
    cdktf-cli
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
      window-decoration = false;
      term = "xterm-256color";
      theme = "Catppuccin Mocha";
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
      window-inherit-working-directory = false;
    };
  };

  programs.rclone = {
    enable = true;
  };

  systemd.user.services.earlyoom-watcher = {
    Unit = {
      Description = "EarlyOOM Log Watcher Notification";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = pkgs.writeShellScript "watch-earlyoom" ''
        # Monitor journal for EarlyOOM kill events
        # grep --line-buffered ensures immediate pipe output
        ${pkgs.systemd}/bin/journalctl -u earlyoom -f -n 0 -o cat | \
        ${pkgs.ripgrep}/bin/rg --line-buffered "sending SIGTERM" | \
        while read -r line; do
          ${pkgs.libnotify}/bin/notify-send \
            -u critical \
            -t 5000 \
            -i dialog-error \
            "EarlyOOM Killer" \
            "$line"
        done
      '';
      Restart = "always";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  };
}
