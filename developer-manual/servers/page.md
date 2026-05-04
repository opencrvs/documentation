# Kubernetes - accessing dbs

Steps to get hold of the secret:

<figure><img src="../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

Decode the secret:

```
k get secret -oyaml postgres-admin-user | yq -r .data.POSTGRES_PASSWORD | base64 -d
```
