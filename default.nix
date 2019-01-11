with import <nixpkgs> {};

let yamlpp = import (fetchTarball "https://github.com/vbgl/yamlpp/archive/ed94512989867af2d916bed279724a576cadd17a.tar.gz"); in

stdenv.mkDerivation {
  name = "opam-coq-archive";

  src =
    let inherit (builtins) filterSource baseNameOf elem; in
    filterSource (p: _: !elem (baseNameOf p) [".git" "result"])
    ./.;

  buildInputs = [ bash lua5_1 lua51Packages.lfs yamlpp ];

  buildPhase = ''
  # Web Pages
    lua scripts/archive2web templates/index.html.in extra-dev released
    mkdir -p $out/
    yamlpp -l en templates/index.html -o $out/index.html
  # OPAM repo
    export OPAM=${opam}/bin/opam
    bash scripts/refresh-opam-indexes extra-dev released core-dev
  '';

  installPhase = ''
    cp www/* $out/
    cp -r extra-dev released core-dev $out/
  '';

}
