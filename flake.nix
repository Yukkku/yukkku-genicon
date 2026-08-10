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
      mkGenicon =
        pkgs:
        pkgs.rustPlatform.buildRustPackage (finalAtters: {
          pname = "yukkku-genicon";
          version = "0.1.0";
          src = ./.;
          cargoHash = "sha256-8ro1NIial0Ydf+UckADN8qJyMH0s/XyRVd+x6kwtbSc=";
          meta = {
            license = pkgs.lib.licenses.mit;
            homepage = "https://github.com/yukkku/yukkku-genicon";
          };
        });
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          yukkku-genicon = mkGenicon pkgs;
        in
        {
          inherit yukkku-genicon;
          default = yukkku-genicon;
        }
      );
      overlays.default = final: _prev: {
        yukkku-genicon = mkGenicon final;
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
