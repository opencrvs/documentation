# Quick Start

### Create a country configuration

```
npm create @opencrvs/countryconfig <project-name>
```

This command creates a country configuration package with a minimal example configuration.

### Run local development environment

Make sure all prerequisites are installed, see [opencrvs-counyryconfig](https://github.com/opencrvs/opencrvs-countryconfig/#prerequisites)

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
