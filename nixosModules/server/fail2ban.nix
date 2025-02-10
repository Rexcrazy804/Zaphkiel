{
  users,
  lib,
  config,
  ...
}: {
  options = {
    servModule.fail2ban = {
      enable = lib.mkEnableOption "Enable fail2ban Service";
    };
  };

  config = lib.mkIf (config.servModule.fail2ban.enable && config.servModule.enable) {
    services.fail2ban = {
      enable = true;
      maxretry = 3;
      ignoreIP = [
        "seraphine.fell-rigel.ts.net"
        "zaphkiel.fell-rigel.ts.net"
        "aria.fell-rigel.ts.net"
      ];

      # Ban IPs for one day on the first ban
      bantime = "48h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        # multipliers = "1 2 4 8 16 32 64 128"; # same functionality as above
        # Do not ban for more than 10 weeks
        maxtime = "1680h";
        overalljails = true;
      };

      # I only require the sshd jail [provided by default on nixos] so this works for now
      # jails = {
      #   apache-nohome-iptables.settings = {
      #     # Block an IP address if it accesses a non-existent
      #     # home directory more than 5 times in 10 minutes,
      #     # since that indicates that it's scanning.
      #     filter = "apache-nohome";
      #     action = ''iptables-multiport[name=HTTP, port="http,https"]'';
      #     logpath = "/var/log/httpd/error_log*";
      #     backend = "auto";
      #     findtime = 600;
      #     bantime  = 600;
      #     maxretry = 5;
      #   };
      # };
    };
  };
}
