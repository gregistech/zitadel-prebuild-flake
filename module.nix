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
    masterKey = mkOption {
      type = types.str;
      description = "Master key that Zitadel uses.";
    };
    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Configuration to append to the config file.";
    };
  };
  

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8080 ];
    systemd.services.zitadel = {
      description = "Starts Zitadel.";
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/zitadel start-from-init --masterkey "${cfg.masterKey}" --config ${configFile} --steps ${configFile}
      '';
    };
  };
}
