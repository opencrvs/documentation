# Deploying to MEC

[https://login.opencrvs.mosip.net/](https://login.opencrvs.mosip.net/)



As of Wed 10th Jan 2024, MEC is still running a detached version of OpenCRVS Core from the branch "openid-connect-national-id-verification", commit hash **1d94147.**

The decision was made to entirely refactor form config after the MEC deployment so you will get confused with this version in package.json.  Essentially MEC is running a stale version of OpenCRVS and work must be done to reconfigure MEC for 1.3.  The plan is to set up a dev environment working with E-Signet using 1.4 then refresh MEC.

```json
1.3.0-beta
```

\
\
ssh ubuntu@52.66.201.138\
Euan & Pyry can add public key to authorized keys.\


### Deployment

[https://github.com/opencrvs/opencrvs-mec](https://github.com/opencrvs/opencrvs-mec)\
Deployment happens with Github Actions. The environment variables are already set up and can just deploy. See `.github/workflows/deploy.yml` to see which version is being deployed.\
\
If you see error: "tee: /var/log/setup-deploy-config.log: Permission denied", you need to run this on the SSH server:

```
sudo chmod 0777 /var/log/setup-deploy-config.log
sudo chmod 0777 /var/log/rotate-secrets.log
```

\
See discussion about the issue here: [https://opencrvsworkspace.slack.com/archives/C04L89EUYQZ/p1675861397944079](https://opencrvsworkspace.slack.com/archives/C04L89EUYQZ/p1675861397944079)

