{pkgs, ...}: let
  port = "8090";
in {
  systemd.user = {
    # I tried figuring this out ended up wanting to kms
    # sockets."filebrowser" = {
    #   enable = true;
    #   description = "Filebrowser activation socket";
    #   wantedBy = ["sockets.target"];
    #   socketConfig = {
    #     ReusePort = "true";
    #     ListenStream = "127.0.0.1:${port}";
    #     Accept = false;
    #   };
    # };
    services."filebrowser" = {
      enable = true;
      description = "User filebrowser service exposing ~/Pictures folder";
      wantedBy = ["default.target"];
      after = ["network.target"];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.filebrowser}/bin/filebrowser -p ${port} -r Pictures/ -d Pictures/filebrowser.db";
      };
    };
  };
}
