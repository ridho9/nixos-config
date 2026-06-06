{ pkgs, config, ... }:
let
  npmGlobal = "${config.home.homeDirectory}/.npm-global";
  minimumReleaseAgeDays = 3;
  minimumReleaseAgeMinutes = minimumReleaseAgeDays * 24 * 60;
  minimumReleaseAgeSeconds = minimumReleaseAgeDays * 24 * 60 * 60;
in
{
  config = {
    home.packages = with pkgs; [
      nodejs
      yarn
      deno
      pnpm

      nest-cli
      # turbo
    ];

    programs.bun.enable = true;

    home.sessionPath = [
      "${config.home.homeDirectory}/.pnpm"
      "${npmGlobal}/bin"
    ];

    home.sessionVariables = {
      PNPM_HOME = "${config.home.homeDirectory}/.pnpm";
      NPM_CONFIG_PREFIX = npmGlobal;
    };

    home.file.".npmrc".text = ''
      prefix=${npmGlobal}
      min-release-age=${toString minimumReleaseAgeDays}
    '';

    # Current pnpm on this machine reads user config from ~/.config/pnpm/rc.
    home.file.".config/pnpm/rc".text = ''
      minimum-release-age=${toString minimumReleaseAgeMinutes}
    '';

    home.file.".bunfig.toml".text = ''
      [install]
      minimumReleaseAge = ${toString minimumReleaseAgeSeconds}
    '';

    # Used by Yarn Berry via Corepack; ignored by Yarn Classic.
    home.file.".yarnrc.yml".text = ''
      npmMinimalAgeGate: ${toString minimumReleaseAgeDays}d
    '';
  };
}
