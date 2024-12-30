{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    libnotify
    # rofi-wayland
    grim
    slurp

    wl-clipboard
    hyprshot
    grimblast
    pavucontrol
    hypridle
    hyprpaper

    pipewire
    wireplumber
    xdg-desktop-portal-hyprland
    hyprpolkitagent

    inputs.hyprland-qtutils.packages."${pkgs.system}".default
  ];

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland.settings = {
    debug = {
      disable_logs = false;
    };

    "$mod" = "SUPER";
    exec-once = [
      "hypridle"
      "hyprpaper"
      "waybar"
      # "hyprctl setcursor BreezeX-Black 32"
      "blueman-applet && blueman-tray"
      "[workspace 1 silent] firefox-devedition"
      "[workspace 2 silent] alacritty"
      "[workspace 10 silent] discord --start-minimized"
      "systemctl --user start hyprpolkitagent"
    ];
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];
    monitor = [
      ", preferred, auto, 1"
    ];
    windowrulev2 = [
      "float,class:(pavucontrol)"
      "float,class:(.blueman-manager-wrapped)"
      # "size 400 300,class:(.blueman-manager-wrapped)"
      # "move  30,class:(.blueman-manager-wrapped)"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
    };
    decoration = {
      rounding = 10;
    };
    bind =
      [
        "$mod SHIFT, Q, killactive"
        "$mod, F, exec, firefox-devedition"
        "$mod, T, exec, alacritty"
        # "$mod, Space, exec, rofi -show drun -show-icons"
        "$mod, Space, exec, fuzzel"
        ", Print, exec, grimblast copysave area | xargs notify-send"

        "$mod, S, togglespecialworkspace, magic"
        "$mod, S, movetoworkspace, +0"
        "$mod, S, togglespecialworkspace, magic"
        "$mod, S, movetoworkspace, special:magic"
        "$mod, S, togglespecialworkspace, magic"

      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ))
        ++ [
          "$mod, code:19, workspace, 10"
          "$mod SHIFT, code:19, movetoworkspace, 10"
        ]
      );
    bindl = [
      ", XF86MonBrightnessUp, exec, xbacklight +5"
      '', XF86MonBrightnessDown, execr, [ "$(xbacklight -get)" -gt 5 ] && xbacklight -5''
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];
    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];
    input = {
      touchpad = {
        scroll_factor = 0.2;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  services.mako = {
    enable = true;
    defaultTimeout = 2000;
  };

  programs.fuzzel = {
    enable = true;
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      indicator = true;
      clock = true;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # lock_cmd = ''notify-send "lock!"''; # dbus/sysd lock command (loginctl lock-session)

        lock_cmd = ''pidof swaylock || swaylock'';
        # unlock_cmd = ''notify-send "unlock!"''; # same as above, but unlock
        before_sleep_cmd = ''pidof swaylock || swaylock''; # command ran before sleep
        # after_sleep_cmd = ''notify-send "Awake!"''; # command ran after sleep

        ignore_dbus_inhibit = false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
        ignore_systemd_inhibit = false; # whether to ignore systemd-inhibit --what=idle inhibitors
      };

      # listener = {
      #   timeout = 500; # in seconds
      #   on-timeout = ''notify-send "You are idle!"''; # command to run when timeout has passed
      #   on-resume = ''notify-send "Welcome back!"''; # command to run when activity is detected after timeout has fired.
      # };
    };
  };

  # services.hyprpaper = {
  #   enable = true;
  #   settings = {
  #     preload = [ "~/Pictures/wallpaper/5.png" ];
  #     wallpaper = [ ",~/Pictures/wallpaper/5.png" ];
  #   };
  # };
}
