{
  fetchFromGitHub,
  sbcl,
  sbclPackages,
}:
sbcl.buildASDFSystem {
  pname = "lem-mailbox";
  version = "2.2.0"; # last version without slop
  src = fetchFromGitHub {
    owner = "lem-project";
    repo = "lem-mailbox";
    rev = "12d629541da440fadf771b0225a051ae65fa342a";
    hash = "sha256-hb6GSWA7vUuvSSPSmfZ80aBuvSVyg74qveoCPRP2CeI=";
  };

  lispLibs = with sbclPackages; [
    bordeaux-threads
    bt-semaphore
    queues
    queues_dot_simple-cqueue
  ];

  systems = ["lem-mailbox"];
}
