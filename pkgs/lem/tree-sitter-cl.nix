{
  fetchFromGitHub,
  sbcl,
  sbclPackages,
}:
sbcl.buildASDFSystem {
  pname = "micros";
  version = "2.2.0"; # last version without slop

  src = fetchFromGitHub {
    owner = "lem-project";
    repo = "tree-sitter-cl";
    rev = "431b572d0e49d64a78320cc5f4b4a90391024ce6";
    hash = "sha256-XbChbpGoS1oDB7r3PiNBqbZUqAAYSgW+vF9xtMqky4Y=";
  };

  lispLibs = with sbclPackages; [
    cffi
    trivial-garbage
  ];

  systems = ["tree-sitter-cl"];
}
