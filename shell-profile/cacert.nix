{ cacert, writeTextFile }:
  writeTextFile {
    name = "shell-cacert-profile";

    derivationArgs.packages = [ cacert ];

    text = ''
      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';
  }
