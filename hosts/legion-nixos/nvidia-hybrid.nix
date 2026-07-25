{
  config,
  pkgs,
  lib,
  ...
}:

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
    powerManagement.finegrained = false; # Disabled to fix suspend/resume hangs
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
  boot.kernelParams = [
    "nvidia.NVreg_DynamicPowerManagement=0x01" # Changed from 0x02 (fine-grained) to 0x01 (coarse) for stability
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"

    # Disable the GSP (GPU System Processor) firmware path.
    #
    # 2026-07-25: resume from hibernate (S4) hard-failed with the GSP faulting
    # inside its own firmware, which left the GPU unusable until reboot:
    #   Xid 120: GSP task exception: instruction access page fault @ pc:0x6a3b005e
    #   Xid 154: GPU recovery action changed from 0x0 (None) to 0x1 (GPU Reset Required)
    # The driver then WARNed in nv_restore_user_channels (nv.c:4451) and oopsed
    # with a NULL deref in nvkms_resume, killing nvidia-sleep.sh with IRQs
    # disabled. That in turn produced -110 timeouts across rtw89, Bluetooth and
    # snd_hda_intel, since interrupts were off for the rest of the resume.
    #
    # Falling back to the CPU-side RM avoids the GSP resume path entirely.
    # Verified present in 595.45.04 via `modinfo -p nvidia | grep EnableGpuFirmware`.
    # Set here rather than in extraModprobeConfig: an unrecognised kernel-cmdline
    # module param is ignored, whereas an unknown `options nvidia ...` line makes
    # modprobe fail outright and would leave the machine without a GPU driver.
    "nvidia.NVreg_EnableGpuFirmware=0"
  ];

  # Where the driver spills VRAM contents when preserving allocations across
  # suspend/hibernate. Unset, this defaults to /tmp -- which works today only
  # because /tmp lives on the root ext4. Pin it to /var/tmp so that enabling
  # boot.tmp.useTmpfs later cannot silently break hibernation.
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';

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
    after = [
      "multi-user.target"
      "tlp.service"
    ];
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
