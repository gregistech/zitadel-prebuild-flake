{
  stdenv,
  lib,
}:
stdenv.mkDerivation rec {
  name = "zitadel-${version}";
  version = "2.0.0-v2-alpha.39";

  src = builtins.fetchurl {
    url = "https://github.com/zitadel/zitadel/releases/download/v${version}/zitadel_Linux_x86_64.tar.gz";
    sha256 = "sha256-v86DTU70bOKFJ8wL6KxxlWC7ymPlywNSoWKJo+h/zHY=";
  };
  sourceRoot = ".";

  installPhase = ''
    install -m755 -D zitadel $out/bin/zitadel
  '';

  meta = with lib; {
    homepage = "https://zitadel.com/";
    description = "The best of Auth0 and Keycloak combined.";
    platforms = platforms.linux;
  };
}
