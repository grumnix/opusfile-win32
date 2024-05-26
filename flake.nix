{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";

    opusfile_src.url = "https://downloads.xiph.org/releases/opus/opusfile-0.12.tar.gz";
    opusfile_src.flake = false;

    libogg.url = "github:grumnix/libogg-win32";
    libogg.inputs.nixpkgs.follows = "nixpkgs";
    libogg.inputs.tinycmmc.follows = "tinycmmc";

    opus.url = "github:grumnix/opus-win32";
    opus.inputs.nixpkgs.follows = "nixpkgs";
    opus.inputs.tinycmmc.follows = "tinycmmc";
  };

  outputs = { self, nixpkgs, tinycmmc, opusfile_src, libogg, opus }:
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
              pkgs.buildPackages.pkg-config
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
