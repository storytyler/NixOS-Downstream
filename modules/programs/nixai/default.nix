{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.programs.nixai;
in {
  options.programs.nixai = {
    enable = mkEnableOption "nixai - AI-powered NixOS assistance tool";

    package = mkOption {
      type = types.package;
      default = inputs.nix-ai.packages.${pkgs.system}.nixai;
      defaultText = "inputs.nix-ai.packages.\${pkgs.system}.nixai";
      description = "The nixai package to use";
    };

    mcp = {
      enable = mkEnableOption "nixai MCP server";

      socketPath = mkOption {
        type = types.str;
        default = "/run/nixai/mcp.sock";
        description = "Path to the MCP server Unix socket";
        example = "/run/nixai/mcp.sock";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Host for the MCP HTTP server to listen on";
        example = "localhost";
      };

      port = mkOption {
        type = types.port;
        default = 39847;
        description = "Port for the MCP HTTP server to listen on";
        example = 39847;
      };

      aiProvider = mkOption {
        type = types.str;
        default = "ollama";
        description = "Default AI provider to use (ollama, claude, groq, gemini, openai, llamacpp, custom)";
        example = "ollama";
      };

      aiModel = mkOption {
        type = types.str;
        default = "llama3";
        description = "Default AI model to use for the specified provider";
        example = "llama3";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra flags to pass to the MCP server";
        example = ["--log-level=debug"];
      };

      environment = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Extra environment variables for the MCP server";
        example = {NIXAI_LOG_LEVEL = "debug";};
      };
    };

    config = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional configuration options for nixai";
    };
  };

  config = mkIf cfg.enable {
    # Install the package
    environment.systemPackages = [cfg.package];

    # Configure MCP server if enabled
    systemd.services.nixai-mcp = mkIf cfg.mcp.enable {
      description = "nixai MCP Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        ExecStart = ''${cfg.package}/bin/nixai mcp-server start --socket-path=${cfg.mcp.socketPath} ${lib.concatStringsSep " " cfg.mcp.extraFlags}'';
        Restart = "on-failure";
        RestartSec = "5s";

        # Security hardening
        DynamicUser = true;
        RuntimeDirectory = "nixai";
        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
      };
      environment = 
        cfg.mcp.environment
        // {
          NIXAI_SOCKET_PATH = cfg.mcp.socketPath;
        };
    };

    # Create default configuration file
    environment.etc."nixai/config.yaml".text = builtins.toJSON ({
      ai_provider = cfg.mcp.aiProvider;
      ai_model = cfg.mcp.aiModel;
      log_level = "info";
      mcp_server = {
        host = cfg.mcp.host;
        port = cfg.mcp.port;
        socket_path = cfg.mcp.socketPath;
        auto_start = cfg.mcp.enable;
      };
    } // cfg.config);
  };
}