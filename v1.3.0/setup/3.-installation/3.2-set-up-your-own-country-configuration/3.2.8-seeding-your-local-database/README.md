# 3.2.8 Seeding your local development environment database

{% hint style="info" %}
Now that your source files are prepared, you are ready to "seed" your OpenCRVS database with data.
{% endhint %}

1. Ensure that OpenCRVS is running, including your countryconfig server by following the instructions in: [**3.1.3 Starting and stopping OpenCRVS**](../../3.1-set-up-a-development-environment/3.1.3-starting-and-stopping-opencrvs.md)**.**
2. Open a new Terminal window and cd inside opencrvs-core:

```
cd opencrvs-core
```

3. Run the following command

```
yarn seed:dev
```

{% hint style="danger" %}
After seeding, the OpenHIM password is reset to the default username: **root@openhim.org** and default password: **openhim-password**. In production environments, it is very important for you to login to OpenHIM and change the password at the following URL:  **https://openhim.\<your-domain>**
{% endhint %}

To seed a server, follow the instructions [here](../../3.3-set-up-a-server-hosted-environment/3.3.7-seeding-and-clearing-data-on-a-server.md).

{% hint style="success" %}
**Now that your database has been seeded, you have completed the country configuration and you can log in to OpenCRVS!**  Proceed to the next step to learn more about some of the important API endpoints exposed by the running countryconfig service.
{% endhint %}
