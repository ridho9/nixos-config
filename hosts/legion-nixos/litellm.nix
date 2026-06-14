{ ... }:

let
  dashboardPort = 9999;
  litellmPort = 4000;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/litellm 0750 root root -"
  ];

  environment.etc."litellm/config.yaml".text = ''
    model_list:
      - model_name: opencode-go/deepseek-v4-flash
        litellm_params:
          model: azure/DeepSeek-V4-Flash
          api_base: os.environ/AZURE_API_BASE
          api_key: os.environ/AZURE_API_KEY
          api_version: os.environ/AZURE_API_VERSION
        model_info:
          input_cost_per_token: 0.00000019
          output_cost_per_token: 0.00000051

    general_settings:
      master_key: os.environ/LITELLM_MASTER_KEY
      database_url: "postgresql://litellm@127.0.0.1:5432/litellm"
      store_model_in_db: true
      store_prompts_in_spend_logs: true
  '';

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "litellm" ];
    ensureUsers = [
      {
        name = "litellm";
        ensureDBOwnership = true;
      }
    ];
    authentication = ''
      local litellm litellm trust
      host litellm litellm 127.0.0.1/32 trust
      host litellm litellm ::1/128 trust
    '';
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers.litellm = {
      image = "docker.litellm.ai/berriai/litellm-database:main-stable";
      autoStart = true;
      volumes = [
        "/etc/litellm/config.yaml:/app/config.yaml:ro"
        "/run/postgresql:/run/postgresql"
      ];
      environmentFiles = [
        "/var/lib/litellm/env"
      ];
      cmd = [
        "--config"
        "/app/config.yaml"
        "--host"
        "127.0.0.1"
        "--port"
        (toString litellmPort)
      ];
      extraOptions = [
        "--network=host"
      ];
    };
  };

  systemd.services.docker-litellm = {
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts.litellm = {
      listen = [
        {
          addr = "0.0.0.0";
          port = dashboardPort;
        }
      ];
      locations."= /ui".extraConfig = "return 302 /ui/;";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString litellmPort}";
        extraConfig = ''
          proxy_redirect http://$host/ /;
          proxy_redirect http://$host:${toString litellmPort}/ /;
        '';
      };
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ dashboardPort ];
}
