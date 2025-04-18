let
  users = {
    rexies = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICELSL45m4ptWDZwQDi2AUmCgt4n93KsmZtt69fyb0vy"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZTLQQzgCvdaAPdxUkpytDHgwd8K1N1IWtriY4tWSvn"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZvsZTvR5wQedjnuSoz9p7vK7vLxCdfOdRFmbfQ7GUd rexies@Seraphine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhkSRUQLV7JpjtPdbFR8vXnJhLhSfbh3vL+j9v/5Bv/ rexies@Aphrodite"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8XCGfozlovdRKSzI8mRL7Bkexk+GoK+WCTWxVmBmDA rexies@Persephone"
    ];
  };

  hosts = {
    Zaphkiel = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZAm8+KGrsCGT7dJbz/Rcm18NslDLrYzzcgHZ4334aa" ];
    Raphael = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJFWrIy+ZoppWlZIG6qHrCfM9yChsKdW39iP5yPeBdl" ];
    Seraphine = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2iNLNXkHv5CXeKy7zhR/bbJ/3SKjp/g/i6l09rjFdZ" ];
    Aphrodite = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILfTXG9nFMbm3Gwkx+RT4ift402Q6sQiQrAKdl3lN3C5" ];
    Persephone = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDva+u9uWAZJzU31JCGfV+uPCRbgGV+vsXUsHdk4lWkr"];
  };
in {
  "secret1.age".publicKeys = users.rexies;
  "secret2.age".publicKeys = hosts.Zaphkiel;
  "secret3.age".publicKeys = hosts.Raphael;
  "secret5.age".publicKeys = hosts.Seraphine;
  "secret6.age".publicKeys = users.rexies;
  "secret8.age".publicKeys = hosts.Aphrodite;
  "secret9.age".publicKeys = hosts.Persephone;

  "media_robin.age".publicKeys = hosts.Zaphkiel ++ hosts.Raphael ++ users.rexies;

  "bak_sak.age".publicKeys = users.rexies;
  "mc_rcon.age".publicKeys = users.rexies ++ hosts.Seraphine;
}
