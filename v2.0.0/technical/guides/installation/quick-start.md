# Quick Start

### Create a country configuration

```
npm create @opencrvs/countryconfig <project-name>
```

This command creates a country configuration package with a minimal example configuration.

### Run local development environment

Make sure all prerequisites are installed, see [opencrvs-countryconfig](https://github.com/opencrvs/opencrvs-countryconfig/#prerequisites)

Navigate to `<project-name>-countryconfig`

Start development environemnt:

```
tilt up
```

Open the Tilt UI:

```
http://localhost:10350
```

Wait until the main resources are running.

Then run the data seed task from the Tilt UI:

1. Open http://localhost:10350
2. Find the `2.Data-tasks` section
3. Run the `data-seed` or `clean-&-seed` resource
4. Wait until the job completes

Open OpenCRVS: http://opencrvs.localhost

Thats it! 🎉

### Further reading on data seeding

Data seeding is the process of installing into OpenCRVS databases, the reference data for general configuration of the application. Seeding is a one-time process. A server or your localhost must be entirely cleared of all data before it can be seeded again.

Data seeding uses a temporary superuser and our APIs to create all of the above. This superuser is created in data migrations that run when OpenCRVS starts up. At the end of data seeding, the superuser is deactivated.

On a deployed server environment, Github Action workflows perform this task. You will learn about them later when provisioning a server.
