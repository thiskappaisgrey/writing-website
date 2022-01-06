{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    nodejs
    elmPackages.elm-language-server
  ];
}
