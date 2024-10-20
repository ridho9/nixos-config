{ config, pkgs, ... }:

{
  imports = [
    ./homeModules/fish.nix
    ./homeModules/lang/nix.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rid9";
  home.homeDirectory = "/home/rid9";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    #  thunderbird
    vscode-fhs
    firefox-devedition
    floorp
    discord

    fastfetch
    gh
  ];

  programs.git = {
    enable = true;
    userName = "ridho9";
    userEmail = "p.ridho9@gmail.com";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "FiraCode Nerd Font";
    };
  };

  # programs.kitty.enable = true; # required for the default Hyprland config
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
      }
    ];
  };

  services.mako.enable = true;
}
