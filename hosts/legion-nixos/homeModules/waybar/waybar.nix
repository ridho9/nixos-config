{ config, pkgs, ... }:
{
  xdg.configFile."waybar/mocha.css".source = ./mocha.css;
  xdg.configFile."waybar/style.css".source = ./waybar.css;
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
          "niri/workspaces"
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [
          "custom/calendar"
        ];
        modules-right = [
          "keyboard-state"
          "pulseaudio"
          "network"
          "group/hardware"
          "backlight"
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
            "class<Godot>" = "";
          };
        };

        "niri/workspaces" = {
          # format = "{icon} {windows} ";
          # window-rewrite-default = "?";
          # window-rewrite = {
          #   "class<firefox>" = "";
          #   "class<discord>" = "";
          #   "class<Code>" = "";
          #   "class<Alacritty>" = "";
          #   "class<Slack>" = "";
          #   "class<steam>" = "";
          #   "class<Godot>" = "";
          # };
        };

        temperature = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          format = "{temperatureC}°C";
        };

        "group/hardware" = {
          orientation = "inherit";
          modules = [
              "cpu"
              "memory"
              "temperature"
          ];
        };

        cpu = {
          interval = 2;
          format = "{usage:>2}% ";
          tooltip = true;
        };

        memory = {
          interval = 2;
          format = "{percentage:>2}% ";
          tooltip-format = "RAM: {used:0.1f}GiB / {total:0.1f}GiB\nSwap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB";
        };

        "custom/calendar" = {
          exec = "${pkgs.writeShellScript "waybar-calendar" ''
            text=$(date +'%H:%M %Y-%m-%d')
            tooltip=$(${pkgs.util-linux}/bin/cal -m -n 6 --color=always | sed -r "s/\x1b\[7m/<span color='#ff6699'><b>/g" | sed -r "s/\x1b\[27m/<\/b><\/span>/g" | sed -r "s/\x1b\[0m/<\/b><\/span>/g" | sed 's/$/\\n/' | tr -d '\n' | sed 's/"/\\"/g')
            echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
          ''}";
          interval = 60;
          return-type = "json";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = " {icon}  {format_source}";
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
            "analog-output" = "";
            "Analog Output" = "";
            "Type-C HiFi Audio Adapter" = "";
            "Type-C HiFi Audio Adapter Analog Stereo" = "";
            "alsa_output.usb-TTGK_Company_Type-C_HiFi_Audio_Adapter_5000000001-01.analog-stereo" = "";
            "analog-output-lineout" = "";
            "analog-output-headphones" = "";
            "lineout" = "";
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
          format = "{icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
      }
    ];
  };
}
