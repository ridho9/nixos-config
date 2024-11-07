{ config, pkgs, ... }:
{
  services.nextdns = {
    enable = true;
    arguments = [
      "-config"
      "changethis"
      "-cache-size"
      "10MB"
    ];
  };
}
