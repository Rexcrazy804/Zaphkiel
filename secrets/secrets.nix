let
  users = {
    rexies = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICELSL45m4ptWDZwQDi2AUmCgt4n93KsmZtt69fyb0vy"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZTLQQzgCvdaAPdxUkpytDHgwd8K1N1IWtriY4tWSvn"
    ];
  };

  hosts = {
    Zaphkiel = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEL+RcwQjikBAOFxI3GSlvB7S0E0groj2I6h4XajvMAy"
    ];
  };
in {
  "secret1.age".publicKeys = users.rexies;
  "secret2.age".publicKeys = hosts.Zaphkiel;
}
