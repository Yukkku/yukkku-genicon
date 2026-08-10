{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      eachSystem = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      mkIcongen =
        pkgs:
        pkgs.rustPlatform.buildRustPackage (finalAtters: {
          pname = "yukkku-genicon";
          version = "0.1.0";
          src = ./.;
          cargoHash = "sha256-Fay9evORbfoc/lmBtWiMoMURWhp9F9GhLpY+xC4KJdY=";
        });
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          yukkku-icongen = mkIcongen pkgs;
        in
        {
          inherit yukkku-icongen;
          default = yukkku-icongen;
        }
      );
      overlays.default = final: _prev: {
        yukkku-icongen = mkIcongen final;
      };

      devShells = eachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            name = "rust environment";
            packages = with pkgs; [
              cargo
              rustc
              rust-analyzer
              rustfmt
              nixd
              nixfmt
            ];
          };
        }
      );
    };
}
