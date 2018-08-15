{	# deps
	system ? builtins.currentSystem,
	nixpkgs ? import <nixpkgs> { inherit system; },
}:

with nixpkgs;

# le one-liner to produce le gemset.nix
# nix-shell -p bundler --command 'bundler package --no-install --path vendor && rm -rf .bundler vendor' && $(nix-build '<nixpkgs>' -A bundix)/bin/bundix && rm result

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
	buildPhase = ''
	'';
	installPhase = ''
			${jekyll_env}/bin/jekyll build --source=$src --destination=$out
	'';

  shellHook = ''
    exec ${jekyll_env}/bin/jekyll serve --watch
  '';
}
