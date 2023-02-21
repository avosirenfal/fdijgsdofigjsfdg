{ pkgs, stashapp ? (
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
mkShell {
  shellHook = ''
  export HOME="/tmp/yarn"
  export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  mkdir /tmp/yarn
  yarn config set prefix /tmp/yarn
  '';

  packages = [ go git yarn gcc gnumake cacert ];
}
