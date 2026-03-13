{
  fetchFromGitHub,
  sbcl,
}:
sbcl.buildASDFSystem {
  pname = "micros";
  version = "2.2.0"; # last version without slop
  src = fetchFromGitHub {
    owner = "lem-project";
    repo = "micros";
    rev = "e1d3857400a9bf7d1c6c2852d9c7017a0dc52217";
    hash = "sha256-NryjqfihHjRo4thBLmdeIaZuCNBFFWVDze55KD6nxrY=";
  };

  systems = ["micros"];
}
