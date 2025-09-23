{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.maria = {
    isNormalUser = true;
    description = "mysql web user";
    # initialPassword option crée le mot de passe système (pour l'utilisateur unix),
    # pas un mot de passe MySQL. Utile si tu veux te logger en tant que dbweb.
    initialPassword = "maria";
  };

  systemd.tmpfiles.rules = [
    "d /var/www 0755 fellwin users -"
    "d /var/www/localhost/ 0755 fellwin users -"
  ];

  services.httpd = {
    enable = true;
    enablePHP = true; # (remplace enablePHP)
    phpPackage = pkgs.php83;
    virtualHosts."localhost" = {
      documentRoot = "/var/www/localhost";
      extraConfig = ''
        <Directory "/var/www/localhost">
          Require all granted
          AllowOverride All
          Options Indexes FollowSymLinks
          DirectoryIndex index.php index.html
        </Directory>
      '';
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialDatabases = [
      {name = "monsite";}
    ];
    ensureUsers = [
      {
        name = "maria"; # correspond à users.users.dbweb
        ensurePermissions = {
          "monsite.*" = "ALL PRIVILEGES";
        };
      }
    ];
    initialScript = pkgs.writeText "mysql-init.sql" ''
      DROP USER IF EXISTS 'maria'@'localhost';
      CREATE USER 'maria'@'localhost' IDENTIFIED BY 'secret';
      GRANT ALL PRIVILEGES ON monsite.* TO 'maria'@'localhost';
      FLUSH PRIVILEGES;
    '';
  };
}
