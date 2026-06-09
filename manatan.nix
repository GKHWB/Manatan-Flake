{
  stdenv,
  fetchurl,
  libgcc,
  wayland,
  glib,
  nspr,
  nss,
  at-spi2-atk,
  cups,
  libxcomposite,
  libxdamage,
  libxrandr,
  libgbm,
  cairo,
  pango,
  udev,
  alsa-lib,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  buildFHSEnv,
}:

let

pkg = stdenv.mkDerivation (finalAttrs: {
  pname = "manatan";
  version = "5.2.7";

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
        x86_64-linux = "sha256-4Jd58k6uotCmULPKYddhVqzB+pUxAaHGUhuVNsFjzLc=";
        aarch64-linux = "sha256-PGKGFmyhIlFvcV9vhtq3sLLBbO/Mb3WHVF7fD1dvFFM=";
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
    # webview
    glib
    nspr
    nss
    at-spi2-atk
    cups.lib
    libxcomposite
    libxdamage
    libxrandr
    libgbm
    cairo
    pango
    udev
    alsa-lib
    # x11
    libx11
    libxcursor
    libxi
    libxkbcommon
    freetype
    libz
    libGL
    glib
    nspr
    nss
    dbus
    at-spi2-core
    cups
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libgbm
    libxcb
    cairo
    pango
    lsof
    udev
    alsa-lib
  ];
}
