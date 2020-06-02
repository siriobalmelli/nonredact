{
  system ? builtins.currentSystem,
  nixpkgs ? import (builtins.fetchGit {
    url = "https://siriobalmelli@github.com/siriobalmelli-foss/nixpkgs.git";
    ref = "master";
    }) {},
}:

with nixpkgs;

# le one-liner to produce le gemset.nix
# nix-shell -p bundler --command 'bundler package --no-install --path vendor && rm -rf .bundler vendor' && $(nix-build '<nixpkgs>' -A bundix)/bin/bundix && rm result

let
  jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    };

in
  stdenv.mkDerivation rec {
    name = "nonredact";
    outputs = [ "out" ];
    buildInputs = [ jekyll_env ];

    src = if lib.inNixShell then null else nix-gitignore.gitignoreSource [] ./.;

    # there is no Makefile and no build products - work with source dir directly
    installPhase = ''
        jekyll build --source=$src --destination=$out
    '';

    shellHook = ''
        exec jekyll serve --watch
    '';
  }
