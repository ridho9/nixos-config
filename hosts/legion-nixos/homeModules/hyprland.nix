{ config, pkgs, ... }:
{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    libnotify
    rofi-wayland
    grim
    slurp

    wl-clipboard
    hyprshot
    grimblast
    pavucontrol
  ];

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    exec-once = [
      "waybar"
      "hyprctl setcursor BreezeX-Black 32"
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
      "size 400 300,class:(.blueman-manager-wrapped)"
      "move 100%-w-0 30,class:(.blueman-manager-wrapped)"
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

  # programs.hyprlock.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  services.mako = {
    enable = true;
    defaultTimeout = 2000;
  };

  programs.fuzzel = {
    enable = true;
  };
}
