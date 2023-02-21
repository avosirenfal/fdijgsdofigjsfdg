{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [];
    }
  )
}:

with pkgs;
stdenv.mkDerivation rec {
  pname = "stashapp";
  version = "v0.19.0";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = "stash";
    rev = "8bd5f91e58619ddbd4245c9ffb765978928f2932";
    sha256 = "sha256-oeQebasL1Y7/0JsVFxJLd4SSDkNe2m6rnkG49TmApXw=";
  };

  shellHook = ''
  '';
  preBuild = ''
  export HOME="/tmp/yarn"
  export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  mkdir /tmp/yarn
  yarn config set prefix /tmp/yarn
  bash
  '';
  postBuild = ''
  '';

  buildInputs = [ go git yarn gcc gnumake cacert ];
  outputHashMode = "flat";
  outputHashAlgo = "sha256";
  outputHash = lib.fakeHash;

  meta = with lib; {
    description = "StashApp";
    homepage = "https://github.com/stashapp/stash";
    platforms = platforms.linux;
  };
}
