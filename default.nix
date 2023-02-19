{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
}:

with pkgs;
buildGoModule rec {
  pname = "stashapp";
  version = "v0.19.0";

  src = fetchFromGitHub {
    owner = "stashapp";
    repo = "stash";
    rev = "8bd5f91e58619ddbd4245c9ffb765978928f2932";
    sha256 = "sha256-oeQebasL1Y7/0JsVFxJLd4SSDkNe2m6rnkG49TmApXw=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "StashApp";
    homepage = "https://github.com/stashapp/stash";
    platforms = platforms.linux;
  };
}
