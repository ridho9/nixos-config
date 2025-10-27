{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    rbw
    rofi-rbw
    wtype
    wl-clipboard
    libnotify
    pinentry-gnome3
  ];

  programs.rofi = {
    enable = true;
  };

  home.file.".config/rbw/config.json".text = builtins.toJSON {
    email = "p.ridho@yahoo.co.id";
    identity_url = null;
    notifications_url = null;
    lock_timeout = 3600;
    sync_interval = 3600;
    pinentry = "${pkgs.pinentry-gnome3}/bin/pinentry-gnome3";
  };

  home.file.".config/rofi-rbw.rc".text = ''
    selector = rofi
    typing-key-delay = 100
    action = type
    clipboarder = wl-copy
    typer = wtype
    clear-after = 30
    use-notify-send
  '';

  xdg.dataFile."applications/bitwarden.desktop".text = ''
    [Desktop Entry]
    Name=Bitwarden
    Comment=Access your Bitwarden passwords
    Exec=${pkgs.rofi-rbw}/bin/rofi-rbw
    Type=Application
    Categories=Utility;Security;
    Keywords=bw;password;rbw;pw;
    Icon=bitwarden
    Terminal=false
  '';

  systemd.user.services.rbw-sync = {
    Unit = {
      Description = "Sync Bitwarden vault with rbw";
      After = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "rbw-sync" ''
        if rbw unlocked; then
          ${pkgs.rbw}/bin/rbw sync
        fi
      ''}";
    };
  };

  systemd.user.timers.rbw-sync = {
    Unit = {
      Description = "Timer for Bitwarden vault sync";
    };

    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "30min";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  home.sessionVariables = {
    PINENTRY_USER_DATA = "USE_CURSES=0";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
