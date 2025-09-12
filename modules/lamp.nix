{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd.tmpfiles.rules = [
    "d /var/www 0755 root root -"
    "d /var/www/localhost 0755 root root -"
    "f /var/www/localhost/index.php 0644 root root - <?php phpinfo();"
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
      {name = "testdb";}
    ];
  };
}
