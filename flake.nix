{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";
    tinycmmc.inputs.flake-utils.follows = "flake-utils";

    opusfile_src.url = "https://downloads.xiph.org/releases/opus/opusfile-0.12.tar.gz";
    opusfile_src.flake = false;

    libogg.url = "github:grumnix/libogg-win32";
    opus.url = "github:grumnix/opus-win32";
  };

  outputs = { self, nixpkgs, flake-utils, tinycmmc, opusfile_src, libogg, opus }:
    tinycmmc.lib.eachWin32SystemWithPkgs (pkgs:
      {
        packages = rec {
          default = opusfile;

          opusfile = pkgs.stdenv.mkDerivation {
            pname = "opusfile";
            version = "0.12";

            src = opusfile_src;

            configureFlags = [
              "--disable-http"
            ];

            nativeBuildInputs = [
              pkgs.buildPackages.pkgconfig
              # pkgconfig
            ];

            buildInputs = [
              libogg.packages.${pkgs.system}.default
              opus.packages.${pkgs.system}.default
            ];
          };
        };
      }
    );
}
