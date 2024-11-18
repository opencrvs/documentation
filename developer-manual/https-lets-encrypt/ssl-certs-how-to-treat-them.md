# SSL certs: how to treat them

Recipe 1: If they are supplied to you: ..

* If there are multiple files, check which file is leaf, intermediate and root if there is one. Should be possible to do this by opening the cert in finder and looking at Subject -> Issuer relationships
* Combine files leaf, intermediate, root order in VSCode.  Using cat to combine the files doesnt work properly. Line breaks are wrong.
* Check md5 hashes match

```
openssl x509 -noout -modulus -in all-in-one-leaf-first.crt | openssl md5
MD5(stdin)= 3faef371ef7524ab98581978e2de7200
```

```
openssl rsa -noout -modulus -in private.key | openssl md5
MD5(stdin)= 3faef371ef7524ab98581978e2de7200
```

You need to change Traefik config to use certs from LetsEncrypt automatic generation to laod from a volume:

```

  traefik:
    command:
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --providers.docker
      - --providers.docker.swarmMode=true
      - --providers.file.directory=/etc/traefik
      - --providers.file.watch=true
      - --api.dashboard=true
      - --api.insecure=true
      - --log.level=WARNING
      - --entrypoints.web.http.redirections.entryPoint.to=websecure
      - --entrypoints.web.http.redirections.entryPoint.scheme=https
      - --entrypoints.web.http.redirections.entrypoint.permanent=true
      - --serverstransport.insecureskipverify=true
      - --entrypoints.websecure.address=:443
      - --accesslog=true
      - --accesslog.format=json
      - --ping=true
    volumes:
      - /etc/ssl:/etc/certs
      - /opt/opencrvs/infrastructure/traefik/certs.yaml:/etc/traefik/certs.yaml

```

In the above example, all-in-one-leaf-first.crt & private.key files are stored in a directory on the server here: /etc/ssl & /etc/ssl/private respectively&#x20;

certs.yaml looks like this:

```
tls:
  stores:
    default:
      defaultCertificate:
        certFile: /etc/certs/all-in-one-leaf-first.crt
        keyFile: /etc/certs/private/private.key
  certificates:
    - certFile: /etc/certs/all-in-one-leaf-first.crt
      keyFile: /etc/certs/private/private.key
      stores:
        - default
```



Recipe 2: If you have to generate them yourself from LetsEncrypt:

Make the cert locally

```
brew install certbot
sudo certbot certonly --manual -d '<your domain>' -d '*.<your domain>'
```

The command will output a DNS TXT record that you must add to the domain within 30 mins&#x20;
