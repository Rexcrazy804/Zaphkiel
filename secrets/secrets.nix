let
  rexies = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3O3+AFsOB67qZFWttGNChSWurtmxsm7OKSfz7SckzN"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICELSL45m4ptWDZwQDi2AUmCgt4n93KsmZtt69fyb0vy"
  ];
in {
  "secret1.age".publicKeys = rexies;
}
