# Translations

It is possible to amend all text copy in OpenCRVS and introduce as as many content translations as you like.

#### **Introduction**

The multi-lingual text content approach for OpenCRVS is developed using [FormatJS](https://formatjs.io/) . It is worthwhile reading their documentation to understand how this technically works, particularly this [page](https://formatjs.io/docs/core-concepts/basic-internationalization-principles).

In the [OpenCRVS country config](https://github.com/opencrvs/opencrvs-countryconfig), all text content is defined in CSV files inside the [src/translations](https://github.com/opencrvs/opencrvs-countryconfig/tree/master/src/translations) directory.&#x20;

You can edit copy at any time, even after OpenCRVS goes live. The code to serve this CSV to the application is provided in the country configuration repo and requires no configuration in order to serve.

The content CSV looks like this:

| id              | description         | en      | fr        |
| --------------- | ------------------- | ------- | --------- |
| buttons.apply   | Apply button label  | Apply   | Appliquer |
| buttons.approve | Approve button text | Approve | Approuver |
| buttons.archive | Archive button text | Archive | Archiver  |

You can add a new language column for every language you want to support. In our Farajaland example you can see that we have added a new column for French.

* The **language column header** is a 2-character [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) language code
* Be sure to add the code of the new language to the comma separated language lists (`LANGUAGES="en,fr"`) found in docker-compose files and `*-config.js` files found in your country config package.
* Some keys like below use the "select" syntax, explained in the [FormatJS Message Syntax documentation](https://formatjs.io/docs/core-concepts/icu-syntax#select-format).

**src/translations/client.csv**

| id                            | description   | en                                                                  | fr                                                                  |
| ----------------------------- | ------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------- |
| system.user.settings.language | Language name | {language, select, en {English} fr {Français} other \{{language\}}} | {language, select, en {English} fr {Français} other \{{language\}}} |
| system.user.settings.language | Language name | {language, select, en {English} fr {Français} other \{{language\}}} | {language, select, en {English} fr {Français} other \{{language\}}} |

**src/translations/login.csv**

| id             | description   | en                                                                  | fr                                                                  |
| -------------- | ------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------- |
| login.language | Language name | {language, select, en {English} fr {Français} other \{{language\}}} | {language, select, en {English} fr {Français} other \{{language\}}} |

* Only update the text content in the language columns. Do not modify the "id" field. You must not remove any keys unless you know that they are not used.  Any removed keys will default to English in the application.

#### Making edits



1. Edit text for the **client** application in CSV in this file: [client.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/master/src/translations/client.csv).&#x20;
2. Edit text for the **login** application in CSV in this file: [login.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/master/src/translations/login.csv) .&#x20;
3. If you are using SMS as a communications gateway, you can edit text in this file: [notification.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/master/src/translations/notification.csv). The descriptions for the use-case of each of these **SMS notifications** content keys is described in the CSV. Explained futher in [Informant and staff notifications](3.3.3-provision-a-comms-gateway.md)
4. Edit **Email subject lines** in [this file](https://github.com/opencrvs/opencrvs-countryconfig/blob/2748b0c86f42f20dd3a053610ed33b6d94593768/src/api/notification/email-templates/index.ts#L122). Edit all **HTML templates** for emails in the appropriate files in [this directory.](https://github.com/opencrvs/opencrvs-countryconfig/tree/develop/src/api/notification/email-templates) Explained futher in [Informant and staff notifications](3.3.3-provision-a-comms-gateway.md)

After editing the content, if the CSV is not valid, it will not load properly in the client.

