{config, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = true;
    startWhenNeeded = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = config.zaphkiel.data.users;
    };

    knownHosts = {
      seraphine = {
        extraHostNames = ["seraphine.fell-rigel.ts.net" "100.112.116.17"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCQgMYa6HbOp2YQvseDyN6pxRmmSGRsWO36atrhEkwgrbCxhnJ8QFcUsDwVayQv1NdNt3qFOq6R8ohN9gGt40Z4HA6Brykcrbp71VjyWuEqacm/20F0KDeQVFmonI0jK2y5uxb53qj0KiQNmEQZtgJUyjtmJRWo7qg2iTmzv/kGfGWC7Qe50ogiLIRXukUJY7VCINgbGaBWhc7a2gPh1njnSkbP7amRvt6nF6lZYoQ/YeYBiuyC2wOpkZEekb/VZuX3wxQuaZ3AJvH9b6OQ3ZWzi+hh/5j/Y8XcL+QRLmZul3pgwuk8v18jO7HQLQsEkEhd4zoAcmyMrOP7RTViUYwiBVcjn3U3TB/z9arunv3iUei0TyYI7JrOmVSeuXwBixxDrjEznYAVYTbJMnUkzS6ucMjV4DwRZeX9yAq8dGXWBXj2RC1dQ/i0SSpPHVI4AMY0fX/JIae1DpSSY1TWQq06eKSRdA3ePovoMqRmY8rbKTX1/414t3qCTGTX/qlJwp+uPjKGNlDUcinPbceNNDuz5VWSHXdBqUAgsg0hraZ2jh0wqFs4uJJZil/LbeN5aSNlEeWgLdtZpcfHTcvbarh9Sa3VcPfzteK17ZTciYBT7m/+d60p5YfQtKUUT8nbBCMhYIox17d+xszl4mUsvxODG7OMLgUdlZrfMxyCqpjGKQ==";
      };
      aphrodite = {
        extraHostNames = ["aphrodite.fell-rigel.ts.net" "100.118.85.124"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQ0y74iTHIC0ta/vCHfcrZes+5CBmAVgLjK83dDSngdGhcsBNiJSe5zDgEXsuyBGhRkAoWNskouJDVv8FMwllCyK43yG9pI4cOGdLJcOyIDdh6dzT+ZF7e9Wzz/HRGO+/k7HwIfmC515vI6xxatFi9ZOAt0mXBDTshEWiCG++o6GD0GnCXPER5EuIUkXGdmvdBoeegz+hMvv0cIfdKyCOuHPT+iyo1GeqxH1IAO6svZ2cahLYB/xXHd0y3qEk/tQZqJ4IMI+xfKGeEc8LAxhmsbLQT/tktACFhbK+nZIzrJcYN/qm0MWaOTapxXnMKREDNIAiAouEUR7pU6lv7u5rAX7L4sL5RZAp0eChSjZOOHEeVR8ijgdq3a2hB9uKm0FQR+JYccZ0n6NqAslUsFobg2a3OCSr18ebnMKL9Zxw7u726pfrljsm0wXNBJf4TF6t/4W0e9EuZq/NhQG++c6nQvq/WcDblKyTnUms4CExudA/K+5uO0+Lt86l2+jIvgqS5LeQhKTxFk2g8uFPSO8Qu207d+QonCLxSObs/poM0hN65prAyKrbAZOskIka+NyHcsXrRcFbwAsemuwyvKVUF2c8N3CPZZylh/MA+scMIzHbwX/bagqChlrHri3nLn6gWwEE0qJ079JWY3Dd+bR9qGO32fs7VzsY/qNj638/miQ== root@Aphrodite";
      };
    };
  };
}
