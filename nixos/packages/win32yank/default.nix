{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (final: {
  pname = "win32yank";
  version = "0.1.1";
  src = fetchurl {
    url = "https://github.com/equalsraf/win32yank/releases/download/v${final.version}/win32yank-x64.zip";
    hash = "sha256-JHyaBblDh6iEtJ09sT+AaxZ338OAIPlV9xm+aQImDNY=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  # a Windows executable, run through WSL interop
  installPhase = ''
    install -Dm755 win32yank.exe $out/bin/win32yank.exe
  '';

  meta = with lib; {
    description = "Windows clipboard tool, for use from WSL";
    homepage = "https://github.com/equalsraf/win32yank";
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = "win32yank.exe";
  };
})
