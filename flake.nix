{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      eachSystem =
        f:
        lib.genAttrs
          [
            "aarch64-darwin"
            "aarch64-linux"
            "i686-linux"
            "x86_64-linux"
          ]
          (
            system:
            let
              pkgs = import nixpkgs { inherit system; };
            in
            f pkgs
          );
      mkGenicon =
        pkgs:
        pkgs.rustPlatform.buildRustPackage (finalAtters: {
          pname = "yukkku-genicon";
          version = "0.1.0";
          src = ./.;
          cargoHash = "sha256-W8Btp7rXfYWifbgIV7JbvOlMFGXaah4NP1lH9ozWmEQ=";
          meta = {
            license = pkgs.lib.licenses.mit;
            homepage = "https://github.com/yukkku/yukkku-genicon";
          };
        });
    in
    {
      packages = eachSystem (pkgs: rec {
        yukkku-genicon = mkGenicon pkgs;
        default = yukkku-genicon;
      });
      overlays.default = final: _prev: {
        yukkku-genicon = mkGenicon final;
      };

      devShells = eachSystem (pkgs: {
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
      });
    };
}
