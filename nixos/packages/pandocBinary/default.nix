{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
}:
stdenv.mkDerivation (final: {
  pname = "pandocBinary";
  version = "3.9.0.2";
  src = fetchurl {
    url = "https://github.com/jgm/pandoc/releases/download/${final.version}/pandoc-${final.version}-linux-amd64.tar.gz";
    sha256 = "a69abfababda8a56969a254b09f9553a7be89ddec00d4e0fe9fd585d71a67508";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
  '';

  meta = with lib; {
      description = "Pandoc ${final.version} binary distribution";
      homepage = "https://pandoc.org";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      mainProgram = "pandoc";
    };
})
