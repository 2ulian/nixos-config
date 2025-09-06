{ config, pkgs, ... }:
{
  # To get the squid certgen
  services.squid.package = pkgs.squid.overrideAttrs (old: {
    # Make disponible dans l'env de build
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.gnumake ];

    # Flags utiles (au cas où)
    configureFlags = (old.configureFlags or [])
      ++ [ "--with-openssl" "--enable-ssl-crtd" ];

    # Conserve les étapes d'origine + ajoute notre build du helper
    postBuild = (old.postBuild or "") + ''
      echo ">>> building security_file_certgen" >&2
      make -C src/security/cert_generators/file security_file_certgen || true
    '';

    # Installe le helper dans $out/libexec + marqueur visible
    postInstall = (old.postInstall or "") + ''
      echo ">>> installing security_file_certgen (if exists)" >&2
      if [ -f src/security/cert_generators/file/security_file_certgen ]; then
        install -Dm0755 src/security/cert_generators/file/security_file_certgen \
          $out/libexec/security_file_certgen
      fi
      echo "certgen-added" > $out/.certgen-marker
    '';
  });


  services.squid = {
    enable = false;

    validateConfig = false;

    configText = ''
      #================= NIXOS SPECIFIC TO AVOID CRASH ================
      pid_filename /run/squid.pid
      # coredump_dir /var/lib/squid # OPTIONAL

      # change the user/group that squid uses for caching
      cache_effective_user squid
      cache_effective_group squid

      # === Logs : forcer /var/log/squid et éviter le daemon ===
      cache_log /var/log/squid/cache.log
      access_log stdio:/var/log/squid/access.log

      # Avoid cache store log to avoid crash
      # cache_store_log none
      #================================================================

      http_port 3128
      http_port 3129 intercept
      https_port 3130 intercept ssl-bump \
          cert=/etc/squid/ssl_mitm/mitmCA.pem \
          key=/etc/squid/ssl_mitm/mitmCA.key \
          generate-host-certificates=on dynamic_cert_mem_cache_size=4MB

      # ← chemin déterministe une fois libexecdir fixé
      sslcrtd_program ${config.services.squid.package}/libexec/security_file_certgen -s /var/lib/squid/ssl_db -M 4MB
      sslcrtd_children 5

      visible_hostname Squid

      #connect_timeout 30 seconds
      #read_timeout 5 minutes
      #client_idle_pconn_timeout 2 minutes
      #server_idle_pconn_timeout 2 minutes

      #sslproxy_session_cache_size 32 MB
      #sslproxy_session_ttl 1 hour

      acl localnet src 10.89.89.0/24
      acl block_http dstdomain .facebook.com .reddit.com
      acl block_sites ssl::server_name .facebook.com .reddit.com

      acl step1 at_step SslBump1
      ssl_bump peek step1
      ssl_bump bump block_sites
      ssl_bump terminate block_sites
      ssl_bump splice all

      http_access deny block_http
      http_access allow localhost
      http_access allow localnet
      http_access deny all
    '';
  };

  # Add certificate to system
  security.pki.certificateFiles = [ ./mitmCA.pem ];

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "enp4s0";
      WIFI_IFACE = "wlp3s0";
      SSID = "Hotspot";
      PASSPHRASE = "bert5654";
    };
  };
}
