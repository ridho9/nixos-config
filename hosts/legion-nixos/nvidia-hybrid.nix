{ config, pkgs, lib, ... }:

{
  # ---------------------------------------------------------------------
  # Nvidia Hybrid Graphics (Optimus) Configuration
  # ---------------------------------------------------------------------

  # 1. Enable Graphics & Nvidia Drivers
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    
    # Power Management (Crucial for turning off dGPU)
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Adds nvidia-offload script
      };
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # 2. Kernel Parameters & Modules
  # Force driver to respect power management
  boot.kernelParams = [ "nvidia.NVreg_DynamicPowerManagement=0x02" ];
  # Enable audio power saving (fix for Audio controller keeping GPU awake)
  boot.extraModprobeConfig = "options snd_hda_intel power_save=1";

  # 3. Udev Rules (The "Big Hammer")
  # Force both Video (030000) and Audio (228e) to 'auto' suspend.
  # This overrides the driver default which often sets them to 'on'.
  services.udev.extraRules = ''
    # Force Nvidia GPU (Video) to auto-suspend
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="auto"
    # Force Nvidia Audio Device (10de:228e) to auto-suspend
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x228e", ATTR{power/control}="auto"
  '';

  # 4. Fail-Safe Systemd Service
  # Ensures 'auto' power control is enforced at boot, even if TLP or driver reverts it.
  systemd.services.force-nvidia-auto = {
    description = "Force Nvidia GPU to Auto Power Control";
    after = [ "multi-user.target" "tlp.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control; echo auto > /sys/bus/pci/devices/0000:01:00.1/power/control'";
    };
  };

  # 5. TLP Integration through settings merge
  # Whitelist Nvidia devices for Runtime PM so TLP doesn't block them.
  services.tlp.settings = {
    RUNTIME_PM_ENABLE = "01:00.0 01:00.1";
    RUNTIME_PM_DRIVER_DENYLIST = "mei_me"; # Exclude 'nvidia' (default) from denylist
  };
}
