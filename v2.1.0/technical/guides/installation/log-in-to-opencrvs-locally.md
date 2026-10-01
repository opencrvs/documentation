# Log in to OpenCRVS locally

Open the url: [**`http://opencrvs.localhost`**](http://opencrvs.localhost)

Use one of the authentication details from the tables below to log in as the user of your choice. When logging in locally, [2FA](https://en.wikipedia.org/wiki/Multi-factor_authentication) is disabled. If you are asked for an authentication code, use 6 zeros.

The users are created when you seed the data, see [Seed and reset data](working-with-tilt.md#seed-and-reset-data). All test users are listed in your country configuration in `src/data-seeding/employees/source/default-employees.csv`. To seed a different set of users for an environment, add an `<environment>-employees.csv` file to the same directory, for example `production-employees.csv`.

To learn more about user roles please refer to [Roles and scopes](../configuration/users/roles-and-scopes.md).

### HQ Office

The national headquarters:

| User                  | Username/Password/2FA                        | Location  |
| --------------------- | -------------------------------------------- | --------- |
| National Registrar    | <p>u. c.lungu<br>p. test<br>c. 000000</p>    | HQ Office |
| Performance Manager   | <p>u. m.musonda<br>p. test<br>c. 000000</p>  | HQ Office |
| National System Admin | <p>u. j.campbell<br>p. test<br>c. 000000</p> | HQ Office |

### Central Province Office

| User                 | Username/Password/2FA                      | Location                |
| -------------------- | ------------------------------------------ | ----------------------- |
| Provincial Registrar | <p>u. m.owen<br>p. test<br>c. 000000</p>   | Central Province Office |
| Local System Admin   | <p>u. e.mayuka<br>p. test<br>c. 000000</p> | Central Province Office |

### Ibombo District (Central Province)

An urban district:

| User               | Username/Password/2FA                       | Location                |
| ------------------ | ------------------------------------------- | ----------------------- |
| Local Registrar    | <p>u. k.mweene<br>p. test<br>c. 000000</p>  | Ibombo District Office  |
| Registration Agent | <p>u. f.katongo<br>p. test<br>c. 000000</p> | Ibombo District Office  |
| Hospital Clerk     | <p>u. k.bwalya<br>p. test<br>c. 000000</p>  | Ibombo District Hospital |
| Community Leader   | <p>u. g.phiri<br>p. test<br>c. 000000</p>   | Klow Village Office     |

### Ilanga District (Sulaka Province)

A provincial district:

| User                 | Username/Password/2FA                          | Location                |
| -------------------- | ---------------------------------------------- | ----------------------- |
| Provincial Registrar | <p>u. m.chikwanda<br>p. test<br>c. 000000</p>  | Sulaka Province Office  |
| Local System Admin   | <p>u. t.nkhoma<br>p. test<br>c. 000000</p>     | Sulaka Province Office  |
| Local Registrar      | <p>u. k.mwale<br>p. test<br>c. 000000</p>      | Ilanga District Office  |
| Registration Agent   | <p>u. c.tayali<br>p. test<br>c. 000000</p>     | Ilanga District Office  |
| Hospital Clerk       | <p>u. m.mazoka<br>p. test<br>c. 000000</p>     | Ilanga District Hospital |

### Embassy offices

| User             | Username/Password/2FA                       | Location              |
| ---------------- | ------------------------------------------- | --------------------- |
| Embassy Official | <p>u. b.moreau<br>p. test<br>c. 000000</p>  | French Embassy Office |
| Embassy Official | <p>u. s.jenkins<br>p. test<br>c. 000000</p> | UK Embassy Office     |
