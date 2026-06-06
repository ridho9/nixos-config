{ pkgs, ... }:

{
  users.users.hermes.extraGroups = [ "docker" ];

  systemd.tmpfiles.rules = [
    "d /srv/hermes-workspaces 0750 hermes hermes -"
    "d /var/lib/hermes/.hermes/cache/documents 0750 hermes hermes -"
  ];

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    container.enable = false;
    workingDirectory = "/srv/hermes-workspaces";
    extraDependencyGroups = [ "messaging" ];
    extraPackages = with pkgs; [
      docker
      neovim
    ];

    environmentFiles = [
      "/var/lib/hermes/env"
    ];

    settings = {
      model = {
        provider = "azure-foundry";
        api_mode = "chat_completions";
        default = "DeepSeek-V4-Flash";
      };

      terminal = {
        backend = "docker";
        cwd = "/workspace";
        timeout = 180;

        docker_image = "nikolaik/python-nodejs:python3.11-nodejs20";
        docker_mount_cwd_to_workspace = false;
        docker_volumes = [
          "/srv/hermes-workspaces:/workspace"
          "/var/lib/hermes/.hermes/cache/documents:/output"
        ];
        docker_forward_env = [ ];

        container_cpu = 4;
        container_memory = 8192;
        container_persistent = true;
      };

      security.redact_secrets = true;
      approvals.mode = "manual";
      compression = {
        enabled = true;
        threshold = 0.50;
      };
    };
  };
}
