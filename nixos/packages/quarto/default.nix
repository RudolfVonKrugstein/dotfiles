{ stdenv
, lib
, pandocBinary
, typst
, esbuild
, deno
, fetchurl
, dart-sass
, rWrapper
, rPackages
, extraRPackages ? []
, makeWrapper
, runCommand
, python3
, quarto
, extraPythonPackages ? ps: with ps; []
, sysctl
}:

stdenv.mkDerivation (final: {
  pname = "quarto";
  version = "1.10.18";
  src = fetchurl {
    url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${final.version}/quarto-${final.version}-linux-amd64.tar.gz";
    sha256 = "afad071b5bd22c02f2d300695743189d3650e0537a53073e654b630cff2b0c73";
  };

  nativeBuildInputs = [
    makeWrapper
    pandocBinary
  ];

  postPatch = ''
    # Compat for Deno >=1.26
    substituteInPlace bin/quarto.js \
      --replace-fail ']))?.trim();' ']))?.trim().split(" ")[0];'
  '';

  dontStrip = true;

  preFixup = ''
    wrapProgram $out/bin/quarto \
      --prefix QUARTO_DENO : ${lib.getExe deno} \
      --prefix QUARTO_PANDOC : ${lib.getExe pandocBinary} \
      --prefix QUARTO_ESBUILD : ${lib.getExe esbuild} \
      --prefix QUARTO_DART_SASS : ${lib.getExe dart-sass} \
      --prefix QUARTO_TYPST : ${lib.getExe typst} \
      ${lib.optionalString (rWrapper != null) "--prefix QUARTO_R : ${rWrapper.override { packages = [ rPackages.rmarkdown rPackages.reticulate ] ++ extraRPackages; }}/bin/R"} \
      ${lib.optionalString (python3 != null) "--prefix QUARTO_PYTHON : ${python3.withPackages (ps: with ps; [ jupyter ipython ] ++ (extraPythonPackages ps))}/bin/python3"}
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share

      rm -r bin/tools

      mv bin/* $out/bin
      mv share/* $out/share

      runHook postInstall
  '';

  passthru.tests = {
    quarto-check = runCommand "quarto-check" {
      nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ sysctl ];
    } ''
      export HOME="$(mktemp -d)"
      ${quarto}/bin/quarto check
      touch $out
    '';
  };

  meta = with lib; {
    description = "Open-source scientific and technical publishing system built on Pandoc";
    mainProgram = "quarto";
    longDescription = ''
        Quarto is an open-source scientific and technical publishing system built on Pandoc.
        Quarto documents are authored using markdown, an easy to write plain text format.
    '';
    homepage = "https://quarto.org/";
    changelog = "https://github.com/quarto-dev/quarto-cli/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ minijackson mrtarantoga ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode binaryBytecode ];
  };
})
