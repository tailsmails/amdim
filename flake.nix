{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          src = ./.;
          preBuild = ''
            export HOME=$(mktemp -d)
          '';
          buildPhase = ''
            export HOME=$TMPDIR
            export XDG_CACHE_HOME=$TMPDIR
            v -prod -cflags "-O3" -o amdim amdim.v
            strip -s amdim 
          '';
          postFixup = ''
            wrapProgram $out/bin/amdim \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.umr ]} 
          '';
          installPhase = ''
            mkdir -p $out/bin;
            mv amdim $out/bin
          '';
          version = "1.0.0";
          pname = "amdim";
          buildInputs = [
            pkgs.vlang
            pkgs.makeWrapper
          ];

          nativeBuildInputs = [
            pkgs.umr
            pkgs.coreutils
          ];

        };
      }
    );
}
