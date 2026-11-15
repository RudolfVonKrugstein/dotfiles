{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, makeWrapper
, coreutils
}:

rustPlatform.buildRustPackage rec {
  pname = "jevr";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "romeromarcelo";
    repo = "jev-retrieval";
    rev = "refs/tags/v${version}";
    hash = "sha256-C1EZK/p1YdgY3VO/f8V6Qa41Vt5wHS2DZS7ltwA7m0Y=";
  };

  cargoHash = "sha256-O7X4o1B17Dg3Ex5owlcmXCMA+dMHFJNmp7UMJ8zLoV8=";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ];

  # jevr only reads TYPESAFE_API_KEY from the environment. If it is unset,
  # fall back to the key file shared with the Jev MCP server and jev.nvim
  # (see nixos/home-manager/jev-mcp-activate.nix).
  postInstall = ''
    wrapProgram $out/bin/jevr --run '
      if [ -z "''${TYPESAFE_API_KEY:-}" ] && [ -s "$HOME/.config/typesafe/key" ]; then
        TYPESAFE_API_KEY="$(${coreutils}/bin/tr -d "[:space:]" < "$HOME/.config/typesafe/key")"
        export TYPESAFE_API_KEY
      fi
    '
  '';

  meta = with lib; {
    description = "Semantic code search for coding agents, backed by TypeSafe Jev";
    homepage = "https://github.com/romeromarcelo/jev-retrieval";
    license = licenses.asl20;
    mainProgram = "jevr";
  };
}
