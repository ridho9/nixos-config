{ config, pkgs, ... }:
{
  xdg.configFile."waybar/mocha.css".source = ./mocha.css;
  xdg.configFile."waybar/style.css".source = ./waybar.css;
  programs.waybar = {
    enable = true;
    # catppuccin.enable = true;
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
          "clock"
        ];
        modules-right = [
          "keyboard-state"
          "pulseaudio"
          "network"
          "backlight"
          "temperature"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon} {windows} ";
          window-rewrite-default = "?";
          window-rewrite = {
            "class<firefox>" = "";
            "class<discord>" = "";
            "class<Code>" = "";
            "class<Alacritty>" = "";
            "class<Slack>" = "";
            "class<steam>" = "";
          };
        };

        temperature = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          format = "{temperatureC}°C";
        };

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
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "󱡏";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%)  ";
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

        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
      }
    ];
  };
}
