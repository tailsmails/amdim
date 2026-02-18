{
  lib,
  stdenv,
  vlang,
  makeWrapper,
  umr,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "amdim";
  version = "1.0.0";

  src = ./.;

  buildInputs = [
    vlang
    makeWrapper
  ];

  nativeBuildInputs = [
    umr
    coreutils
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    export XDG_CACHE_HOME=$TMPDIR
    v -prod -cflags "-O3" -o amdim amdim.v
    strip -s amdim
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv amdim $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/amdim \
      --prefix PATH : ${lib.makeBinPath [ umr ]}
  '';

  meta = {
    description = "Low-level hardware control utility for AMD GPUs on Linux";
    homepage = "https://github.com/ehsan2003/amdim";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "amdim";
  };
}
