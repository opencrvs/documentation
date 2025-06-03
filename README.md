# OpenCRVS Gitbook documentation

This repository has all source files for OpenCRVS documentation found from [documentation.opencrvs.org](https://documentation.opencrvs.org/).

## How to sync previous documentation version to a newer one?

In some cases after a release is published (e.g. 1.7) you might want to sync the last minute changes to all proceeding documentation directories (v1.8.0) you can do so with the following command (change the versions accordingly)

```
./sync-between-versions.sh v1.7.0 v1.8.0
```

This command syncs all files from v1.7.0 to v1.8.0. As some changes might get overwritten, make sure to carefully go through the Git diff before pushing the changes.