with import <nixpkgs> {};

let yamlpp = import (fetchTarball "https://github.com/vbgl/yamlpp/archive/ed94512989867af2d916bed279724a576cadd17a.tar.gz"); in

stdenv.mkDerivation {
  name = "opam-coq-archive";

  src =
    let inherit (builtins) filterSource baseNameOf elem; in
    filterSource (p: _: !elem (baseNameOf p) [".git" "result"])
    ./.;

  buildInputs = [ lua5_1 lua51Packages.lfs yamlpp ];

  buildPhase = ''
    lua scripts/archive2web templates/index.html.in extra-dev released
    mkdir -p $out/
    yamlpp -l en templates/index.html -o $out/index.html
  '';

  installPhase = ''
    cp www/* $out/
  '';

}
