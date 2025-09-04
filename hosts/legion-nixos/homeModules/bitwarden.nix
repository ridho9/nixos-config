{ config, pkgs, lib, ... }:

{
  # Bitwarden packages
  home.packages = with pkgs; [
    rbw
    rofi-rbw
    wtype  # For autotyping on Wayland
    wl-clipboard  # For clipboard operations
    libnotify  # For notifications
    pinentry-gnome3  # GNOME pinentry for password prompts
  ];

  # RBW (Bitwarden CLI) configuration
  home.file.".config/rbw/config.json".text = builtins.toJSON {
    email = "p.ridho@yahoo.co.id";  # Replace with your Bitwarden email
    # base_url = null;  # Uncomment and set if using self-hosted Vaultwarden
    identity_url = null;
    notifications_url = null;
    lock_timeout = 3600;  # Auto-lock after 1 hour
    sync_interval = 3600;
    pinentry = "${pkgs.pinentry-gnome3}/bin/pinentry-gnome3";
  };

  # Automatic Bitwarden sync service
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

  # Timer to run sync every 30 minutes when vault is unlocked
  systemd.user.timers.rbw-sync = {
    Unit = {
      Description = "Timer for Bitwarden vault sync";
    };
    
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "30min";  # Sync every 30 minutes
      Persistent = true;
    };
    
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # Custom fuzzel-bitwarden script
  home.file.".local/bin/fuzzel-bitwarden" = {
    text = ''
      #!/usr/bin/env bash
      
      # Bitwarden fuzzel integration script
      
      if ! rbw unlocked; then
          # If vault is locked, show unlock dialog
          MASTER_PASS=$(echo "" | fuzzel --dmenu --prompt="Bitwarden Master Password: " --password)
          if [[ -n "$MASTER_PASS" ]]; then
              echo "$MASTER_PASS" | rbw unlock
              # Sync after unlock to get latest data
              rbw sync
          else
              exit 1
          fi
      else
          # Check if we should sync (if last sync was > 30 minutes ago)
          LAST_SYNC=$(stat -c %Y ~/.local/share/rbw/db.json 2>/dev/null || echo 0)
          CURRENT_TIME=$(date +%s)
          if (( CURRENT_TIME - LAST_SYNC > 1800 )); then  # 30 minutes
              rbw sync &  # Sync in background
          fi
      fi
      
      # Get all entries
      ENTRY=$(rbw list --fields name,user | fuzzel --dmenu --prompt="Bitwarden: " --width=60)
      
      if [[ -n "$ENTRY" ]]; then
          NAME=$(echo "$ENTRY" | cut -f1)
          
          # Ask what to do with the entry
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

  # Environment variables for rbw and Wayland
  home.sessionVariables = {
    # Ensure pinentry works in Wayland
    PINENTRY_USER_DATA = "USE_CURSES=0";
    # Enable Wayland for Qt applications (including pinentry-qt)
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
