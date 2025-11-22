{
  dandelion.modules.openssh = {config, ...}: {
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
          extraHostNames = ["aphrodite.fell-rigel.ts.net" "100.121.86.4"];
          publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj4+zp8vOmlV6WXx/zLcaQ9EWVdAnjg/eHdC2WTYPbigOp0vhrAkJourj4UkVJC3F/SwJBrJEEY6KqczNS8ZGEFXv613KIpb22Xs5O3uV8Aa5/pRYOPnnVJ0lIldhFj3KxZbpMNW6ojWOAXaJk34m6VjNIkZxcUlxOZOEq4xdjekO73G9sTTE4DmWVQRbZ9Yu4qyKl74CVpA2avmw8usgvaR0mb3fdhfS3g4xHAI9h9osD8qqIbGI5rS7ycJM44/gwLc/Y5NRRv+ckIWtPupcvPKSgGbvh+7sTGSbFD1VHRwqkSYPbJ6fBkwUUD44nS2GyysSxvjfkQRNhAbxa+QxuTyUYMKjC+R07c3ZRz+GIQNTBNL4Y4fTgMwIWUErv687PINXwrVRUDE3IZBy1hYl+ecDgvruk202xQKF3+wHaEXcD6js3ayfg0hGPx40OZeaQWYaHZPYaReKHOxvIIOy/P+E7ls6DFJ2s/JCbVnpoKFysXnPMqiF8feVE7AjVU/c=";
        };
      };
    };
  };
}
