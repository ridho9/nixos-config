{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libnotify
    rofi-wayland
  ];

  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    exec-once = [
      "waybar"
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
    general = {
      gaps_in = 5;
      gaps_out = 10;
    };
    decoration = {
      rounding = 10;
    };
    bind =
      [
        "$mod, F, exec, floorp"
        "$mod, T, exec, alacritty"
        "$mod, Space, exec, rofi -show drun -show-icons"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
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
        )
      );
    input = {
      touchpad = {
        scroll_factor = 0.2;
      };
    };
  };

  programs.waybar = {
    enable = true;
    package = (
      pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    );
    settings = [
      {
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "backlight"
          "battery"
          "clock"
        ];
      }
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.mako = {
    enable = true;
    defaultTimeout = 2000;
  };
}
