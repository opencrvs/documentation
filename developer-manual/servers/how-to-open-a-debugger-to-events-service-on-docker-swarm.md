# How to open a debugger to events service on Docker Swarm

How to open a debugger to events service on Docker Swarm\
<br>

1. Modify the service so it spawns the service with a debugger enabled

```
docker service update   --args "sh -c 'cd /app/packages/events && TS_NODE_BASEURL=./build/dist/src node --inspect=0.0.0.0:9229 -r tsconfig-paths/register build/dist/src/index.js'" opencrvs_events
```

&#x20;2\. Expose 9229 from container to host machine

```
docker service update \
  --publish-rm 9229 \
  --publish-add published=9229,target=9229,mode=host \
  opencrvs_events
```

3\. Open up an SSH tunnel from your machine to the host machine

```
ssh -L 9229:localhost:9229 riku@farajaland-staging.opencrvs.org   
```

***

\
Country config starts like this with a debugger

```
docker service update   --entrypoint "/bin/sh"   --args "-c 'cd /usr/src/app && sed -i \"s|yarn start:prod|node --inspect=0.0.0.0:9229 -r ts-node/register/transpile-only -r tsconfig-paths/register src/index.ts|\" start-prod.sh && exec ./start-prod.sh'"   opencrvs_countryconfig
```

Remove inspector from a service

```
docker service update \
  --publish-rm published=9229,target=9229,mode=host \
  opencrvs_events

```

```
docker service update \
  --args "" \
  opencrvs_events
```

\
Open Postgres up to 5422 port

```
docker service update   --publish-add published=5422,target=5432,mode=host   opencrvs_postgres
```

