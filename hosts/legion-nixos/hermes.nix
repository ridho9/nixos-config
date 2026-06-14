{ pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /var/lib/hermes/.hermes 2770 hermes hermes -"
    "d /var/lib/hermes/workspace 2770 hermes hermes -"
    "z /var/lib/hermes/.hermes/.env 0660 hermes hermes -"
  ];

  system.activationScripts.hermesHomePermissions.text = ''
    mkdir -p /var/lib/hermes/.hermes /var/lib/hermes/workspace
    chown hermes:hermes /var/lib/hermes /var/lib/hermes/.hermes /var/lib/hermes/workspace
    chmod 2770 /var/lib/hermes /var/lib/hermes/.hermes /var/lib/hermes/workspace
    if [ -e /var/lib/hermes/.hermes/.env ]; then
      chown hermes:hermes /var/lib/hermes/.hermes/.env
      chmod 0660 /var/lib/hermes/.hermes/.env
    fi
  '';

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    container = {
      enable = true;
      backend = "docker";
      image = "ubuntu:24.04";
      hostUsers = [ "rid9" ];
      extraVolumes = [
        "/home/rid9/nixos-config:/mnt/nixos-config:ro"
      ];
    };

    workingDirectory = "/data/workspace";
    extraDependencyGroups = [ "messaging" ];
    extraPackages = with pkgs; [
      curl
      fd
      git
      jq
      neovim
      ripgrep
      tree
    ];

    environmentFiles = [
      "/var/lib/hermes/env"
    ];

    settings = {
      model = {
        provider = "custom";
        api_mode = "chat_completions";
        base_url = "http://127.0.0.1:4000/v1";
        api_key = "\${LITELLM_API_KEY}";
        default = "opencode-go/deepseek-v4-flash";
      };

      agent = {
        reasoning_effort = "xhigh";
      };

      terminal = {
        backend = "local";
        cwd = "/data/workspace";
        timeout = 180;
      };

      display = {
        tool_progress = "all";
        tool_progress_command = true;
      };

      security = {
        redact_secrets = true;
        allow_private_urls = false;
        tirith_enabled = true;
        tirith_fail_open = false;
      };
      approvals = {
        mode = "smart";
        timeout = 30;
        cron_mode = "deny";
        mcp_reload_confirm = true;
        destructive_slash_confirm = true;
      };
      compression = {
        enabled = true;
        threshold = 0.50;
      };
    };
  };
}
