{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      forAllSystems' = systems: fun: nixpkgs.lib.genAttrs systems fun;
      forAllSystems = forAllSystems' supportedSystems;
    in
      with nixpkgs.lib;
      {
        overlays.ricochet = final: prev:
          {
            ricochet = final.callPackage ./ricochet.nix {};
          };

        overlay = self.overlays.ricochet;

        packages = forAllSystems (system:
          let
            pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.ricochet ]; };
          in
            {
              inherit (pkgs)
                ricochet;
            }
        );

        defaultPackage = forAllSystems (system:
          let
            pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.ricochet ]; };
          in
            pkgs.ricochet
        );

        defaultApp = self.defaultPackage;
        apps = self.packages;

        devShell = forAllSystems (system:
          let
            pkgs = import nixpkgs { inherit system; overlays = mapAttrsToList (_: id) self.overlays; };
          in
            pkgs.mkShell {
              nativeBuildInputs = with pkgs.qt5; with pkgs;
                [ wrapQtAppsHook qmake
                  pkg-config protobuf
                  tor
                ];
              buildInputs = with pkgs.qt5;
                [ qtbase qttools qtquickcontrols qtdeclarative qtmultimedia
                ];
            }
        );

      };
}
