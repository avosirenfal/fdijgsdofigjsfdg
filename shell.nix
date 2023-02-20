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
  packages = [
    go git yarn gcc gnumake
  ];
}
