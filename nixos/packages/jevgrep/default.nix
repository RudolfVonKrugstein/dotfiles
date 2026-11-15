{ lib
, buildNpmPackage
, fetchurl
, jq
, nodejs_22
}:

# Built from the published npm tarball (already bundled); the upstream repo is a
# bun/turbo monorepo. package-lock.json covers only the runtime dependencies,
# regenerate it on upgrade:
#   tar xzf jevgrep-<v>.tgz && cd package
#   jq 'del(.devDependencies, .scripts)' package.json > p && mv p package.json
#   npm install --package-lock-only --ignore-scripts
buildNpmPackage rec {
  pname = "jevgrep";
  version = "0.8.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/@dzhng/jevgrep/-/jevgrep-${version}.tgz";
    hash = "sha256-CLaECmq9+Fy3FUstc/hDaz1nlfyZQJKwaSdMtsrk2q0=";
  };

  nodejs = nodejs_22;
  npmDepsHash = "sha256-JeoA9JsU0MKCSaBxeN+fgxUoiUWu+i3VQ2Am1csVjqU=";

  # devDependencies use `workspace:*`, which npm cannot resolve outside the monorepo
  postPatch = ''
    ${jq}/bin/jq 'del(.devDependencies, .scripts)' package.json > package.json.tmp
    mv package.json.tmp package.json
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = with lib; {
    description = "Find code by asking what it does, using TypeSafe Jev";
    homepage = "https://github.com/dzhng/jevgrep";
    license = licenses.mit;
    mainProgram = "jg";
  };
}
