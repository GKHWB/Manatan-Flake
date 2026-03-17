{ 
  stdenv,
  fetchurl,
  libgcc,
  wayland,
  libxkbcommon,
  buildFHSEnv,
}:

let

pkg = stdenv.mkDerivation (finalAttrs: {
  pname = "manatan";
  version = "3.3.12";

  src = 
  let
    selectSystem =
      attrs:
      attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: %{stdenv.hostPlatform.system}");
    system = selectSystem {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
    };
  in
    fetchurl {
      url = "https://github.com/KolbyML/Manatan/releases/download/v${finalAttrs.version}/Manatan-v${finalAttrs.version}-Linux-${system}.tar.gz";
      sha256 = selectSystem {
        x86_64-linux = "sha256-7oqkiJzgwT8TM/Op7Slt5TbKmPcv2KIS2xx2KpuAUVo=";
        aarch64-linux = "sha256-GpcslMER+/iPaN1rLqr3zcMVHS9uRSatPw8tVybYNQE=";
      };
    };

  buildInputs = [
    libgcc
  ];

  sourceRoot = ".";

  installPhase = ''
    install -m755 -D manatan $out/bin/manatan
  '';

  runtimeDependencies = [ 
    wayland 
    libxkbcommon
  ];

  meta = {
    homepage = "https://manatan.com";
    description = "Seamless immersion language learning for anime, manga, novels on all platforms";
  };
});

in

buildFHSEnv {
  inherit (pkg) pname version;

  runScript = "${pkg.outPath}/bin/manatan";

  targetPkgs = pkgs: with pkgs; [
    fontconfig
    wayland
    libxkbcommon
    freetype
    libz
    libGL
  ];
}
