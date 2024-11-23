let
  users = {
    rexies = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICELSL45m4ptWDZwQDi2AUmCgt4n93KsmZtt69fyb0vy"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZTLQQzgCvdaAPdxUkpytDHgwd8K1N1IWtriY4tWSvn"
    ];
  };

  hosts = {
    Zaphkiel = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZAm8+KGrsCGT7dJbz/Rcm18NslDLrYzzcgHZ4334aa"
    ];
    Raphael = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJFWrIy+ZoppWlZIG6qHrCfM9yChsKdW39iP5yPeBdl"
    ];
  };
in {
  "secret1.age".publicKeys = users.rexies;
  "secret2.age".publicKeys = hosts.Zaphkiel;
  "secret3.age".publicKeys = hosts.Raphael;
  "secret4.age".publicKeys = users.rexies;
}
