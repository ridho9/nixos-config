{ config, pkgs, ... }:
{
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
        "$mod, Space, exec, rofi -show drun -show-icons"
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
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [
          # "hyprland/window"
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "backlight"
          "battery"
          "tray"
          # "clock"
        ];

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          # format-alt = "{:%Y-%m-%d}";
          format = "{:%H:%M %Y-%m-%d}";

          calendar = {
            format = {
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = " ";
            hands-free = "󱡏 ";
            headset = "󰋎 ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
      }
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  services.mako = {
    enable = true;
    defaultTimeout = 2000;
  };
}
