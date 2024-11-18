# 4.2.5.1 Managing language content



{% embed url="https://www.youtube.com/watch?v=Ti0qHBwWTFo" %}

It is possible to amend all text copy in OpenCRVS and introduce as as many content translations as you like.

#### **Technical background**

The multi-lingual text content approach for OpenCRVS is developed using [FormatJS](https://formatjs.io/) . It is worthwhile reading their documentation to understand how this technically works, particularly this [page](https://formatjs.io/docs/core-concepts/basic-internationalization-principles).

In the [OpenCRVS country config](https://github.com/opencrvs/opencrvs-countryconfig), all text content is defined in CSV files inside the [src/translations](https://github.com/opencrvs/opencrvs-countryconfig/tree/master/src/translations) directory. The contents of these files can be edited in a spreadsheet program like Microsoft Excel or Numbers. Import the file you want to edit and export it back to a CSV once all changes have been made. Alternatively you can use a code editor like VSCode to modify the files, explained in step [3.1.5 Tooling](../../../3.1-set-up-a-development-environment/3.1.5-tooling/).

#### **Editing text content**

You can edit copy at any time, even after OpenCRVS goes live. The code to serve this CSV to the application is provided in the country configuration repo and requires no configuration in order to serve.

The content CSV looks like this:

| id              | description         | en      | fr        |
| --------------- | ------------------- | ------- | --------- |
| buttons.apply   | Apply button label  | Apply   | Appliquer |
| buttons.approve | Approve button text | Approve | Approuver |
| buttons.archive | Archive button text | Archive | Archiver  |

You can add a new language column for every language you want to support. In our Farajaland example you can see that we have added a new column for French.

* The **language column header** is a 2-character [ISO 639-1](https://en.wikipedia.org/wiki/List\_of\_ISO\_639-1\_codes) language code
* When you add a new language column, you also need to update all translation items that translate ISO codes to human readable language names. In the application, for example the language selection dropdowns are dependent on these translations. At least the following files and items need to be updated. Read more about the "select" syntax in the [FormatJS Message Syntax documentation](https://formatjs.io/docs/core-concepts/icu-syntax#select-format).
* Also be sure to add the code of the new language to the comma separated language lists (`LANGUAGES="en,fr"`) found in docker-compose files and `*-config.js` files found in your country config package.

**src/translations/client.csv**

| id                            | description   | en                                                                  | fr                                                                  |
| ----------------------------- | ------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------- |
| system.user.settings.language | Language name | {language, select, en {English} fr {Français} other \{{language\}}} | {language, select, en {English} fr {Français} other \{{language\}}} |
| system.user.settings.language | Language name | {language, select, en {English} fr {Français} other \{{language\}}} | {language, select, en {English} fr {Français} other \{{language\}}} |

**src/translations/login.csv**

| id             | description   | en                                                                  | fr                                                                  |
| -------------- | ------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------- |
| login.language | Language name | {language, select, en {English} fr {Français} other \{{language\}}} | {language, select, en {English} fr {Français} other \{{language\}}} |



* Only update the text content in the language columns. **Do not modify the "id" field**. **You must not remove any keys as they are ALL required.**
* The **value** uses the [unicode ICU Message Syntax](https://unicode-org.github.io/icu/userguide/format\_parse/messages/) approach using braces {} and English variables to occasionally substitute dynamic text. You must read the [unicode documentation](https://unicode-org.github.io/icu/userguide/format\_parse/messages/) and understand how this works if you are editing these values. Dynamic variables must remain in English.

1. Edit text for the **client** application in CSV in this file: [client.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/master/src/translations/client.csv). The descriptions for the use-case of each of these **client** content keys is described in the CSV.
2. Edit text for the **login** application in CSV in this file: [login.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/master/src/translations/login.csv) . The descriptions for the use-case of each of these **login** content keys is described in the CSV.
3. Edit **SMS notifications** in this file: [notification.csv](https://github.com/opencrvs/opencrvs-countryconfig/blob/master/src/translations/notification.csv). The descriptions for the use-case of each of these **SMS notifications** content keys is described in the CSV.  You should also refer to [**3.2.5.1.1 Informant & staff notifications**](3.3.3-provision-a-comms-gateway.md)
4. Edit **Email subject lines** in [this file](https://github.com/opencrvs/opencrvs-countryconfig/blob/2748b0c86f42f20dd3a053610ed33b6d94593768/src/api/notification/email-templates/index.ts#L122). Edit all **HTML templates** for emails in the appropriate files in [this directory.](https://github.com/opencrvs/opencrvs-countryconfig/tree/develop/src/api/notification/email-templates)  You should also refer to [**3.2.5.1.1 Informant & staff notifications**](3.3.3-provision-a-comms-gateway.md)

Some dynamic content is rendered using ICU Message Syntax, explained here: [https://formatjs.io/docs/core-concepts/icu-syntax](https://formatjs.io/docs/core-concepts/icu-syntax)

For example, in cases like the below, the areas in **bold** are the areas to translate and you leave the rest of the syntax in English as it is code:

{year}-**Farajaland**-{event, select, birth{**birth**} death{**death**} other{**birth**\}}-event-statistics.csv {fileSize}\
This is the most complex example:

{event, select, declaration \{{eventType, select, birth {**birth**} death {**death**} other{**birth**\}} **declaration has been sent for review.**} registration \{{eventType, select, birth {**birth**} death {**death**} other{**birth**\}} **has been registered.**} duplication \{{eventType, select, birth {**birth**} death {**death**} other{**birth**\}} **has been registered.**} rejection \{{eventType, select, birth {**birth**} death {**death**} other{**birth**\}} **declaration has been rejected.**} certificate \{{eventType, select, birth {**birth**} death {**death**} other{**birth**\}} **certificate has been completed.**} offline \{{eventType, select, birth {**birth**} death {**death**} other{**birth**\}} **declaration will be sent when you reconnect.**} other \{{eventType, select, birth {**birth**} death {**death**} other{birth\}}}

After editing the content, if the CSV is not valid, it will not load properly in the client. You can use an online validator like [this one](https://csvlint.io/) to check that your CSV is valid.&#x20;

####
