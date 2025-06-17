{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation rec {
  pname = "void-editor";
  version = "1.99.30039";

  src = pkgs.fetchurl {
    url = "https://github.com/voideditor/binaries/releases/download/${version}/Void-linux-x64-${version}.tar.gz";
    sha256 = "sha256-1XzsybjQuT5pMfmSZtg17EW4Ym9uwYVjFj0kvpyciCA=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
  ];

  buildInputs = [
    pkgs.mesa
    pkgs.alsa-lib
    pkgs.xorg.libxkbfile
    pkgs.xorg.libX11
    pkgs.xorg.libXcomposite
    pkgs.xorg.libXdamage
    pkgs.xorg.libXfixes
    pkgs.xorg.libXrandr
    pkgs.nss
    pkgs.nspr
    pkgs.gtk3
    pkgs.pango
    pkgs.atk
    pkgs.cairo
    pkgs.cups
    pkgs.libxkbcommon
    pkgs.at-spi2-core
    pkgs.expat
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    tar -xzvf $src -C $out
    mkdir -p $out/share/applications
    cat > $out/share/applications/void-editor.desktop <<EOF
    [Desktop Entry]
    Name=Void Editor
    Comment=Open Source AI Code Editor
    Exec=$out/bin/void --password-store=basic
    Icon=$out/resources/app/resources/linux/code.png
    Terminal=false
    Type=Application
    Categories=Development;IDE;
    EOF
    runHook postInstall
  '';

  meta = {
    description = "Void Editor, Open Source AI Code Editor";
    homepage = "https://voideditor.com";
    license = pkgs.lib.licenses.asl20;
    maintainers = with pkgs.lib.maintainers; [ ];
  };
}
