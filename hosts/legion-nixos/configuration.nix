# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/options.nix
    ../../modules/nixos/stylix.nix
    ./niri.nix
    ./nvidia-hybrid.nix
  ];

  specialisation = lib.mkForce { };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = "auto";
    cores = 8;
    auto-optimise-store = true;
    warn-dirty = false;
    builders-use-substitutes = true;
    http-connections = 128;
    max-substitution-jobs = 128;
  };

  # Kernel & Power Optimizations
  boot.kernelParams = [ "amd_pstate=active" ];

  boot.kernel.sysctl = {
    "vm.vfs_cache_pressure" = 50;
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
  };

  nix.gc = {
    automatic = false;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # OOM Prevention
  # OOM Prevention
  # OOM Prevention
  services.earlyoom = {
    enable = true;
    enableNotifications = false;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "legion-nixos";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.enableRedistributableFirmware = true;
  networking.networkmanager.enable = true;

  time.timeZone = lib.mkDefault "Asia/Jakarta";
  i18n.defaultLocale = "en_SG.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.ly.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.polkit.enable = true;

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  users.users.rid9 = {
    isNormalUser = true;
    description = "rid9";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "video"
      "input"
      "docker"
      "systemd-journal"
    ];
    shell = pkgs.fish;
    hashedPassword = "$6$AzOsDEZH9zFSF0AT$g9pxQMibYSOm390jTMiTzYhxT50yM8AsjDAbCfmqkwKT4VdddZ8xTu.3dC44yOsiCt24dniIBNJDZaKfOIGws1";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      mySystem = config.mySystem;
    };
    users.rid9 = {
      imports = [
        ./home-manager.nix
        inputs.catppuccin.homeModules.catppuccin
      ];
    };

    backupFileExtension = "hm-backup";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    git-lfs
    tig
    jujutsu
    zip
    unzip

    nh
    nvd
    nix-output-monitor

    alacritty

    egl-wayland
    ddcutil
    os-prober
    git-crypt

    gtk3
    gtk4

    swayimg

    btop
    bruno
    sqlite
    sqlite-web

    protobuf
    lm_sensors
    i2c-tools

    cachix
    gcc

    kind
    pkg-config
    mariadb
    ripgrep

    gnumake

    zig
    zls

    tree
    file

    libsecret
    polkit_gnome
    jq

    file-roller
  ];

  programs.nh.enable = true;
  programs.nh.clean.enable = true;
  programs.nh.clean.extraArgs = "--keep-since 14d --keep 5";
  programs.nh.flake = "/home/rid9/nixos-config";

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };

  system.stateVersion = "24.05";

  time.hardwareClockInLocalTime = true;

  environment.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  };

  # Power Management (TLP + Thermald)
  services.power-profiles-daemon.enable = false; # Conflict with TLP
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  services.thermald.enable = true;

  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  services.logind.settings = {
    Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
  };

  security.pam.services.swaylock = { };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    login.enableGnomeKeyring = true;
    ly.enableGnomeKeyring = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.flatpak.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  # programs.file-roller.enable = true;
  xdg.mime.defaultApplications."inode/directory" = "thunar.desktop";
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  catppuccin.flavor = "mocha";

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    trusted-users = root rid9
  '';

  hardware.xpadneo.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "beekeeper-studio-5.5.3" ];

  boot.supportedFilesystems = [ "ntfs" ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  programs.fuse.userAllowOther = true;
}
