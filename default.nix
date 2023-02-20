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

  wrappedYarn = yarn.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs or [] ++ [ makeBinaryWrapper ];
    postInstall = oldAttrs.postInstall or "" + ''
      wrapProgram $out/bin/yarn \
        /*--add-flags "--global-folder /tmp/yarn --global-link /tmp/yarn2"*/
        --append-flags "--help"
    '';
  });

  buildInputs = [ go git wrappedYarn gcc gnumake ];
  outputHashMode = "flat";
  outputHashAlgo = "sha256";
  outputHash = lib.fakeHash;

  meta = with lib; {
    description = "StashApp";
    homepage = "https://github.com/stashapp/stash";
    platforms = platforms.linux;
  };
}
