{pkgs, ...}: {
  # TEMP
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  users.users.rexies.packages = [
    pkgs.mysql-workbench
    # graphical interface for gnome keyring
    pkgs.seahorse
  ];

  # gnome keyring, might needa look into this later
  # and make it a permanent addition
  services.gnome.gnome-keyring.enable = true;
}
