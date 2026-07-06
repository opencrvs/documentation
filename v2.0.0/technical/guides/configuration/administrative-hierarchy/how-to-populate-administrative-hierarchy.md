# How to populate administrative hierarchy

## Populating administrative hierarchy

After completing all the following steps, you will be ready to seed administrative areas, locations, and users, and use them in event form fields.\
<br>

1. Specify the available administrative structures in [application configuration](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/api/application/application-config.ts)\
   \
   Specifying the available structures allows **events** to utilise administrative areas as configurable fields. Once you have specified the structure, configure translations for them in [client.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/translations/client.csv).
2. Define administrative areas in [administrative-areas.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/data-seeding/locations/source/administrative-areas.csv). Administrative areas form the core of your administrative hierarchy.<br>
3. Define locations in [locations.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/data-seeding/locations/source/locations.csv). Locations are more precise places where users are assigned and events may occur (e.g. hospitals). Since locations reference administrative areas, they must be seeded after them.<br>
4. Define user roles in [roles.ts](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/data-seeding/roles/roles.ts). Each user must have a role and location. <br>
5. Define users. In development environments, test users are seeded from [default-employees.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/data-seeding/employees/source/default-employees.csv). In production, users are seeded from [prod-employees.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/data-seeding/employees/source/prod-employees.csv). Seeding multiple users is not recommended in production environments.<br>

<br>
