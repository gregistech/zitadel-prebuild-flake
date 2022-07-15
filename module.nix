self: {
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.zitadel;
  
  configFile = pkgs.writeText "zitadel.yaml" ''
    ${cfg.extraConfig}
  '';

in {
  options.services.zitadel = {
    enable = mkEnableOption {
      description = "Enables Zitadel.";
    };
    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.default;
      description = "Zitadel package to use.";
    };
    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Configuration to append to the config file.";
    };
    extraConfigFile = mkOption {
      type = types.path;
      default = cfg.configFile;
      description = "Extra configuration file.";
    };
    extraCommand = mkOption {
      type = types.str;
      default = "";
      description = "Anything to append to the start command.";
    };
  };
  

  config = mkIf cfg.enable {
    systemd.services.zitadel = { # FIXME: does not wait for DB
      description = "Starts Zitadel.";
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = ''
        sleep 30
        ${cfg.package}/bin/zitadel start-from-init --config ${configFile} --steps ${configFile} ${cfg.extraCommand}
      '';
      path = [ pkgs.coreutils ];
    };
  };
}
