{
  config,
  pkgs,
  lib,
  ...
}: {
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
  };
}
