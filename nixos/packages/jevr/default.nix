{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, makeWrapper
, coreutils
}:

# Built from the fork's main branch, which adds more searchable extensions
# (nix, lua, ... and qmd docs) to upstream's hardcoded list in src/walk.rs.
# To update: set `rev` to the new main commit, replace both hashes with
# lib.fakeHash, rebuild and copy in the reported hashes.
rustPlatform.buildRustPackage {
  pname = "jevr";
  version = "0.2.2-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "RudolfVonKrugstein";
    repo = "jev-retrieval";
    rev = "631b7bf3047fbef82e385ef37cfcefe3e9fceed8";
    hash = "sha256-6XEtKZSAsbzzAdcP11AClLYJkfKV2sr1Nk9t0VvuNSA=";
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
