# Quick Start

### Fork (or clone) repositories

Create your own forks from the following repositories:

* [https://github.com/opencrvs/opencrvs-countryconfig](https://github.com/opencrvs/opencrvs-countryconfig): This repository is used to store OpenCRVS Country configuration.&#x20;
* [https://github.com/opencrvs/infrastructure](https://github.com/opencrvs/infrastructure): Repository is used to store Infrastructure and CI/CD configuration (ansible inventory files and helm release values).

**Steps to fork a repository:**

1. Go to [https://github.com/opencrvs/infrastructure](https://github.com/opencrvs/infrastructure) or [https://github.com/opencrvs/opencrvs-countryconfig](https://github.com/opencrvs/opencrvs-countryconfig)
2. In the top right corner press "Fork" button
3. Provide "Owner" and "Repository name" values
4. Press "Create fork" button.

**For CI/CD:**

Create a [Github Personal Access Token ](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)with the required permissions in order for the script to programmatically create Github environments on your forked repository. Usually, the only required scope for the token is "repo".

{% hint style="warning" %}
Set the token expiration time as needed. Keep in mind that the token secret must be updated regularly for deployment actions to continue working after it expires.
{% endhint %}
