let
  users = {
    rexies = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICELSL45m4ptWDZwQDi2AUmCgt4n93KsmZtt69fyb0vy"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZTLQQzgCvdaAPdxUkpytDHgwd8K1N1IWtriY4tWSvn"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZvsZTvR5wQedjnuSoz9p7vK7vLxCdfOdRFmbfQ7GUd rexies@Seraphine"
    ];
  };

  hosts = {
    Zaphkiel = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZAm8+KGrsCGT7dJbz/Rcm18NslDLrYzzcgHZ4334aa"
    ];
    Raphael = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJFWrIy+ZoppWlZIG6qHrCfM9yChsKdW39iP5yPeBdl"
    ];
    Seraphine = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2iNLNXkHv5CXeKy7zhR/bbJ/3SKjp/g/i6l09rjFdZ"
    ];
  };
in {
  "secret1.age".publicKeys = users.rexies;
  "secret2.age".publicKeys = hosts.Zaphkiel;
  "secret3.age".publicKeys = hosts.Raphael;
  "secret4.age".publicKeys = users.rexies;
  "secret5.age".publicKeys = hosts.Seraphine;
  "secret6.age".publicKeys = users.rexies;
  "secret7.age".publicKeys = hosts.Seraphine;

  "media_kok.age".publicKeys = users.rexies;
  "media_robin.age".publicKeys = hosts.Zaphkiel ++ hosts.Raphael ++ users.rexies;
  "media_kok_exquisite.age".publicKeys = users.rexies;

  "bak_sak.age".publicKeys = users.rexies;
}
