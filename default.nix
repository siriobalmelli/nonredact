{	# deps
	system ? builtins.currentSystem,
	nixpkgs ? import <nixpkgs> { inherit system; },
}:

with nixpkgs;

let jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    ruby = ruby_2_5;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation rec {
    name = "nonredact";
		outputs = [ "out" ];
    buildInputs = [
			git
			jekyll_env
			which
		];

	# just work with the current directory (aka: Git repo), no fancy tarness
	src = ./.;
	buildPhase = "${jekyll_env}/bin/jekyll build --source=$src --destination=$out";

  shellHook = ''
    exec ${jekyll_env}/bin/jekyll serve --watch
  '';
}
