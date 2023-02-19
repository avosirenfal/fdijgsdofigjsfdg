{ pkgs, stashapp ? (
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

let
  goEnv = pkgs.mkGoEnv { pwd = ./.; src = stashapp; };
in
pkgs.mkShell {
  packages = [
    goEnv
    pkgs.gomod2nix
  ];
}
