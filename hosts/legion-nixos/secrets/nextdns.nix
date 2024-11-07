{ config, pkgs, ... }:
{
  services.nextdns = {
    enable = true;
    arguments = [
      "-config"
      "test"
      "-cache-size"
      "10MB"
    ];
  };
}
