{ pkgs ? import <nixpkgs> {} }:

let
    herdsman_source = pkgs.fetchgit {
        url = "https://github.com/herd-fhe/herdsman.git";
        rev = "v0.0.5";
        sha256 = "57dd367146bc505dde9dd8aff6dfc63c76c5881ba09e6d5c86b76f28f260aa6a";
    };

    herdsman = import herdsman_source { inherit pkgs; };

    config_file = pkgs.writeTextDir "/herdsman/herdsman.yaml" ''
        ---
        server:
          hostname: localhost
          port: 4999
          key_directory: "/storage/key"
          storage_directory: "/storage/data_frame"

        logging:
          level: DEBUG

        security:
          secret_key: "Nzc4MzM0ZjU0MmEwYmQ2MGM2OTA1ZjFjNDg1YTMxODk"

        workers:
          grpc:
            addresses:
              - hostname: localhost
                port: 5001
        '';
    nginx_config = pkgs.writeTextDir "/etc/nginx/nginx.conf" ''
      user nobody nobody;
      daemon off;
      error_log /dev/stdout info;
      pid /dev/null;
      events {}
      http {
        access_log /dev/stdout;
        server {
          listen 5000 http2;
          location / {
            client_max_body_size 50M;
            grpc_bind 127.0.0.1;
            grpc_pass grpc://127.0.0.1:4999;
          }
        }
      }
    '';

    supervisord_config = pkgs.writeTextDir "/etc/supervisor/supervisord.conf" ''
        [supervisord]
        nodaemon = true
        user = root
        loglevel = info
        logfile = /dev/null
        logfile_maxbytes=0
        pidfile = /supervisord.pid
        directory = /

        [program:herdsman]
        directory = /herdsman
        command = ${herdsman}/bin/herdsman
        redirect_stderr = true
        autostart=true
        stdout_logfile = /dev/stdout
        stdout_logfile_maxbytes = 0

        [program:nginx]
        command = ${pkgs.nginx}/bin/nginx -c ${nginx_config}/etc/nginx/nginx.conf
        redirect_stderr = true
        autostart=true
        stdout_logfile = /dev/stdout
        stdout_logfile_maxbytes = 0
    '';
in

with pkgs;

dockerTools.buildImage {
    name = "herdsman";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
        name = "image-root";
        paths = [
            fakeNss
            herdsman
            config_file
            nginx
            nginx_config
            python311Packages.supervisor
            supervisord_config
        ];
        pathsToLink = [ "/bin" "/herdsman" "/etc" ];
    };

    extraCommands = ''
      mkdir -p tmp/nginx_client_body

      # nginx still tries to read this directory even if error_log
      # directive is specifying another file :/
      mkdir -p var/log/nginx
    '';

    config = {
        Cmd = [ "supervisord" "-c" "/etc/supervisor/supervisord.conf" ];
        ExposedPorts = {
            "5000/tcp" = {};
        };
    };
}
