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

/**
forbidden power

in another shell:
socat -d -d TCP4-LISTEN:4444 STDOUT

  preBuild = ''
  export HOME="/tmp/yarn"
  export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  mkdir /tmp/yarn
  yarn config set prefix /tmp/yarn
  socat TCP4:127.0.0.1:4444 EXEC:'${pkgs.bash}/bin/bash -li',pty,stderr,setsid,sigint,sane
  sleep 99999
  '';
**/
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

  dontInstall = true;
  postConfigure = ''
  export HOME="/tmp/yarn"
  export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  #export PATH="$PATH:/build/source/ui/v2.5/node_modules/.bin"
  mkdir /tmp/yarn
  yarn config set prefix /tmp/yarn

  make pre-ui
  substituteInPlace /build/source/ui/v2.5/node_modules/.bin/gql-gen \
    --replace "/usr/bin/env node" "${pkgs.nodejs}/bin/node"
  substituteInPlace /build/source/ui/v2.5/node_modules/.bin/vite \
    --replace "/usr/bin/env node" "${pkgs.nodejs}/bin/node"
  #socat exec:'${pkgs.bash}/bin/bash -li',pty,stderr,setsid,sigint,sane tcp:127.0.0.1:4444
  #sleep 99999
  '';

  postBuild = ''
  mkdir -p $out/bin
  cp /build/source/stash $out/bin
  '';

  buildInputs = [ go git yarn gcc gnumake cacert nodejs ];
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-KkDoNLkJhgPXBaNKCPTIWCt2zm19LxF1eV9IQ9dNSzA=";

  meta = with lib; {
    description = "StashApp";
    homepage = "https://github.com/stashapp/stash";
    platforms = platforms.linux;
  };
}
