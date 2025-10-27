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

  home.file.".config/rbw/config.json".text = builtins.toJSON {
    email = "p.ridho@yahoo.co.id";
    identity_url = null;
    notifications_url = null;
    lock_timeout = 3600;
    sync_interval = 3600;
    pinentry = "${pkgs.pinentry-gnome3}/bin/pinentry-gnome3";
  };

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

  home.file.".local/bin/fuzzel-bitwarden" = {
    text = ''
      #!/usr/bin/env bash

      if ! rbw unlocked; then
          MASTER_PASS=$(echo "" | fuzzel --dmenu --prompt="Bitwarden Master Password: " --password)
          if [[ -n "$MASTER_PASS" ]]; then
              echo "$MASTER_PASS" | rbw unlock
              rbw sync
          else
              exit 1
          fi
      else
          LAST_SYNC=$(stat -c %Y ~/.local/share/rbw/db.json 2>/dev/null || echo 0)
          CURRENT_TIME=$(date +%s)
          if (( CURRENT_TIME - LAST_SYNC > 1800 )); then
              rbw sync &
          fi
      fi

      ENTRY=$(rbw list --fields name,user | fuzzel --dmenu --prompt="Bitwarden: " --width=60)

      if [[ -n "$ENTRY" ]]; then
          NAME=$(echo "$ENTRY" | cut -f1)
          
          ACTION=$(echo -e "Copy Password\nCopy Username\nCopy TOTP\nAuto-type\nShow Details\nSync Vault" | fuzzel --dmenu --prompt="Action: ")
          
          case "$ACTION" in
              "Copy Password")
                  rbw get "$NAME" | wl-copy
                  notify-send "Bitwarden" "Password copied to clipboard"
                  ;;
              "Copy Username")
                  rbw get --field=username "$NAME" | wl-copy
                  notify-send "Bitwarden" "Username copied to clipboard"
                  ;;
              "Copy TOTP")
                  rbw code "$NAME" | wl-copy
                  notify-send "Bitwarden" "TOTP code copied to clipboard"
                  ;;
              "Auto-type")
                  USERNAME=$(rbw get --field=username "$NAME")
                  PASSWORD=$(rbw get "$NAME")
                  wtype "$USERNAME" && sleep 0.1 && wtype -k Tab && sleep 0.1 && wtype "$PASSWORD"
                  ;;
              "Show Details")
                  rbw get --field=notes "$NAME" | fuzzel --dmenu --prompt="Notes: " || true
                  ;;
              "Sync Vault")
                  rbw sync
                  notify-send "Bitwarden" "Vault synchronized with server"
                  ;;
          esac
      fi
    '';
    executable = true;
  };

  home.sessionVariables = {
    PINENTRY_USER_DATA = "USE_CURSES=0";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
