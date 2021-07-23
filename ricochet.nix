{ stdenv
, fetchFromGitHub
, lib

, qt5, libsForQt5
, pkg-config, protobuf
, tor
}:
with lib;
let
  version = "3.0.10";
in
stdenv.mkDerivation {
  inherit version;
  pname = "ricochet";

  buildInputs = with qt5;
    [ qtbase qttools qtquickcontrols qtdeclarative qtmultimedia
    ];

  nativeBuildInputs = with qt5;
    [ wrapQtAppsHook qmake
      pkg-config protobuf
    ];

  patchPhase = ''
    sed -i 's/\$\$\[QT_INSTALL_BINS\]\/lrelease/lrelease/' src/tego_ui/tego_ui.pro
  '';

  preConfigure = ''
    cd src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ../build/release/tego_ui/ricochet-refresh $out/bin
    ln -s ${tor}/bin/tor $out/bin
  '';

  # qtWrapperArgs = [ "--prefix PATH : \"${tor}/bin\"" ];

  qmakeFlags = [ "DEFINES+=RICOCHET_NO_PORTABLE" "CONFIG+=ltcg" ];

  src = fetchFromGitHub {
    owner = "blueprint-freespeech";
    repo = "ricochet-refresh";
    rev = "v${version}-release";
    sha256 = "sha256-bNb5srYplM/nhj5ISRJKifVWb2+P3hYy/rMMFbNaKPY=";

    fetchSubmodules = true;
  };
}
