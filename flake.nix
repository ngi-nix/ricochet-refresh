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

        apps = mapAttrs (_: v:
          mapAttrs (_: a:
            {
              type = "app";
              program = a;
            }
          ) v
        ) self.packages;

        defaultApp = mapAttrs (_: v:
          v.ricochet
        ) self.apps;

        devShell = forAllSystems (system: self.packages.${system}.ricochet);
      };
}
