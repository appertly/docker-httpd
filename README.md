# docker-httpd
Docker image of httpd with more throrough settings and a FastCGI connection to a PHP-FPM Docker image. Ports 80 and 443 are exposed.

## General config

The content root is configured for the httpd image default, which is `/usr/local/apache2/htdocs`. You can change the `DocumentRoot` by specifying the `HTTPD_DOCUMENT_ROOT` environment variable.

## PHP/HHVM

The server configuration dispatches all `.php` requests to a FastCGI backend listening on port 9000. You must launch this container using the `--link your-container-name:fpm` argument.

## SSL

SSL is enabled. There are three files that will be automatically generated if they're not provided by you.

* `/usr/local/apache2/conf/dhparam.pem`: Diffie-Hellman parameter for DHE ciphersuites (will auto-generate a 2048 bit file if not provided)
* `/usr/local/apache2/conf/server.key`: RSA private key (will auto-generate a 4096 bit key if not provided)
* `/usr/local/apache2/conf/server.crt`: X.509 public certificate (will auto-generate a self-signed certificate if not provided)

### CA Certificates
You can mount a volume to `/usr/local/share/ca-certificates` that contains any certificate authorities you wish to accept as trusted. Debian's `update-ca-certificates` is run before httpd executes.
