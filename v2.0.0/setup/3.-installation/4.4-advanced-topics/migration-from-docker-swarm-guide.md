# Migration from Docker swarm guide

## Before you begin

Following tutorial will guide you through all steps required to transform your docker swarm infrastructure to Kubernetes and redeploy OpenCRVS on it. Please carefully check this section before moving forward.

OpenCRVS v2.0+ has dedicated repository for continuous delivery configuration, see [https://github.com/opencrvs/infrastructure](https://github.com/opencrvs/infrastructure). Before running migration you will need to fork this repository to your organisation or personal account, see steps later.

Migration workflow works with following environments only:

* development
* qa
* staging
* production

Following environments are deprecated:

* `backup` is merged into production while migration and is managed as part of production environment by Provision workflow.
* `jumpbox` is not used anymore

Any customisations made to docker-compose files needs to be re-implemented using Helm chart.

`provision` user on docker manager server must have access to backup server by ssh key without password, see configuration steps later

Single server docker environments are converted to single server Kubernetes environments.

Multi node docker environments are converted to Kubernetes clusters with worker nodes. Migration script doesn't support multiple docker manager nodes.

## Preparation steps

1. Upgrade country config repository to OpenCRVS v1.9.6+
2. Fork infrastructure repository (manual step)
3. Create GitHub token with access to both repositories:
   1. Country config repository
   2. Infrastructure repository
4. Add token as a repository level secret `MIGRATION_GH_TOKEN` to Country config repository
5. Grant provision user on docker manager access to backup server by ssh key:
   1.  Login on production docker manager and get `provision` user public key:<br>

       ```
       sudo -i
       su - provision
       ssh-keygen -N "" -t ed25519 -f /home/provision/.ssh/id_ed25519 > /dev/null && \
       echo '' && \
       cat /home/provision/.ssh/id_ed25519.pub
       ```
   2.  Copy public key value from output (example value):

       ```
       provision@prod-1:~$ ssh-keygen -N "" -t ed25519 -f /home/provision/.ssh/id_ed25519 && echo '' && cat /home/provision/.ssh/id_ed25519.pub

       ssh-ed25519 AAAAC3NzaC1lZDI1NTE5pxmslgDlhTRXKbc7mUReqhDUla+8nm8JJc6UFvRb47r provision@prod-1
       ```
   3.  Login on backup server as provision user and add public key from production to `/home/provision/.ssh/authorized_keys` on backup server:<br>

       ```
       sudo -i
       su - provision
       echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5pxmslgDlhTRXKbc7mUReqhDUla+8nm8JJc6UFvRb47r provision@prod-1' > /home/provision/.ssh/authorized_keys
       ```

## Migration process

1. Navigate to Country config repository
2.  Run "Migration swarm to k8s" GitHub actions workflow

    <figure><img src="../../../.gitbook/assets/image (22).png" alt=""><figcaption></figcaption></figure>

    1. "The environment to migrate": Environment choosen for migration, you may migrate environments one by one or altogether
    2. "The target organisation owner": GitHub organisation or your personal account who owns Infrastructure repository
    3. "The target infrastructure repository": GitHub infrastructure repository name
3.  Verify workflow execution results:\
    On the screenshot execution results for single environment are shown, make sure all steps completed successfully.

    <figure><img src="../../../.gitbook/assets/image (20).png" alt=""><figcaption></figcaption></figure>
4. Verify target repository:
   1. Navigate to Infrastructure repository
   2. Navigate to Settings -> Environments: Make all repository and environment level secrets and variables have been created
   3.  Navigate to Settings -> Actions -> Runners: Make sure self-hosted runners are available for each migrated environment. If you run migration for one environment only, you will find only one runner. NOTE: Environment name is a part of runner name and one of the runner tags, e/g "development" on the screenshot

       <figure><img src="../../../.gitbook/assets/image (23).png" alt=""><figcaption></figcaption></figure>


5.  Navigate to "Pull requests" section: You will find PR with all changes required to deploy new environment with Kubernetes.

    <figure><img src="../../../.gitbook/assets/image (25).png" alt=""><figcaption></figcaption></figure>


6. Review changes within PR. If your docker-compose file have any customisations like environment variables, please add them to `environments/<env name>/opencrvs-services/values.yaml`
7. Merge Pull request to main (develop) branch.
8. Provision Kubernetes environment on top of Docker Swarm environment: Run Provision workflow from Infrastructure repository, see for more information [4.3.5-provisioning-servers](../3.3-set-up-a-server-hosted-environment/4.3.5-provisioning-servers/ "mention")
9. Reboot your target server
10. Deploy dependencies, see for more information [4.3.6.1-running-a-deployment.md](../3.3-set-up-a-server-hosted-environment/4.3.6-deploy/4.3.6.1-running-a-deployment.md "mention")
11. Deploy OpenCRVS: see for more information [4.3.6.1-running-a-deployment-1.md](../3.3-set-up-a-server-hosted-environment/4.3.6-deploy/4.3.6.1-running-a-deployment-1.md "mention")
    1. Use same OpenCRVS Core image tag as docker swarm
    2. Use same Country config image tag as docker swarm
    3. Make sure "Enable data seeding during deployment" is unchecked

## Post migration steps

### Configure approval users list

Production environment (staging might be as well) requires additional control over deployments and other tasks to avoid unexpected downtime or any other issues. All workflows will require approvals on production environment by default. To configure allowed approvers, please set repository level variable `GH_APPROVERS`. Variable contains a comma separated list of GitHub accounts responsible for Reviews and Approvals on OpenCRVS GitHub Actions workflows. This variable is defined at repository level.

