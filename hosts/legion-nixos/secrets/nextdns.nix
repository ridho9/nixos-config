{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nextdns
  ];

  services.nextdns = {
    enable = true;
    arguments = [
      "-profile"
      "affa1d"
      "-cache-size"
      "10MB"
    ];
  };
}
