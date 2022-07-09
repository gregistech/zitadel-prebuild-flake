{
  description = "The best of Auth0 and Keycloak combined.";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
  };

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { 
        system = "x86_64-linux"; 
        config = { allowUnfree = true; };
      };

    stdenv.mkDerivation rec {
      name = "zitadel-${version}";
      version = "v2.0.0-v2-alpha.39";

      src = pkgs.fetchurl {
              url = "https://github.com/zitadel/zitadel/releases/download/${version}/zitadel_Linux_x86_64.tar.gz";
              sha256 = "sha256-v86DTU70bOKFJ8wL6KxxlWC7ymPlywNSoWKJo+h/zHY=";
      };
      sourceRoot = ".";
      
      installPhase = ''
      install -m755 -D zitadel $out/bin/zitadel
      '';

      meta = with lib; {
              homepage = "https://zitadel.com/";
              description = self.description;
              platforms = platforms.linux;
      };
    };
    #overlays.default = self.overlay;
    nixosModules.zitadel = 
      { lib, options, config, ...  }: 
        with lib;
      {
        cfg = config.services.zitadel;
        nixpkgs.overlays = [ self.overlays.default ];
        
        options.services.zitadel = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Enables Zitadel.";
          };
        };
        
        config.services.zitadel = mkIf cfg.enable {
          systemd.services.zitadel = {
            description = "Starts Zitadel.";
            wantedBy = [ "multi-user.target" ];
            serviceConfig.ExecStart = "${pkgs.zitadel}/bin/zitadel start-from-init";
          };
        };
      };
  };
}

# github.com/thegergo02/zitadel-prebuild-flake
