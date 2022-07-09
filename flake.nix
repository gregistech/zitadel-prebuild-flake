{
  description = "The best of Auth0 and Keycloak combined.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    packages."x86_64-linux".default = nixpkgs.legacyPackages."x86_64-linux".callPackage ./zitadel.nix {};
    nixosModules.default = import ./module.nix self;
  };
}
