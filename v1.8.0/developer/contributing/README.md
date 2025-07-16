# Contributing

This documentation is intended for developers working daily as part of the OpenCRVS Core team, as well as external contributors who wish to contribute occasionally.

Here you’ll find documentation on our best practices, developer workflows, and the automation we use for feature development, bug fixing, and other day-to-day development tasks.



### Raising a bug or a feature request

1. Before opening a bug or feature request, use the search tool on the [Git issues page](https://github.com/opencrvs/opencrvs-core/issues) in opencrvs-core to see if the issue request already exists.
2. Open a Git Issue in opencrvs-core and complete the full template of choice if your request does not already exist.
3. Open a [Github discussion](https://github.com/opencrvs/opencrvs-core/discussions) and link to the Git Issue in your comments.  In the discussion, please explain a bit about who you are, the project you are working on, and maybe the country associated.  With this information, we can expedite urgent requests.

{% hint style="warning" %}
We are automatically notified in our Slack when a new Github Discussion is created, so this is a great way to get our attention.
{% endhint %}

### What happens next

During the following week after receiving your Github Discussion and request, we will prioritise it and get back to you. &#x20;

If the request is a legitimate bug in opencrvs-core and affects the core business processes of birth and death registration, we will deem it a **high priority** and get back to you with a resolution pathway within 1 week.

If the request is a bug in your configuration, our community will offer some advice when we have the capacity to do so. &#x20;

If your feature request is in our backlog, but not prioritised for an upcoming release, then we will get back to you as soon as we can with a potential design and development approach.

At your own pace you can submit a hotfix or feature response in a pull-request following the [process](submitting-a-hotfix.md) defined on the next page.

{% hint style="warning" %}
OpenCRVS is a highly curated and secure government system that must support any of our implementation countries as a Digital Public Good.  Our design guidelines can be discussed between us based on research analysis and your country's unique requirements, but the OpenCRVS Core team's decision on approach will need to cater for every country's needs.  Our decision will be final.  If you want your submission to be accepted into an official release.  You can always fork OpenCRVS to deploy unsupported changes that are unique to your needs and bypass our security and quality gates.  OpenCRVS accepts no responsibility to help bug-fix any forked code.
{% endhint %}

Your pull request will need to have adequate test coverage.  We use a fake country configuration called Farajaland in order to write [playwright end-to-end](https://github.com/opencrvs/opencrvs-farajaland/tree/develop/e2e) tests.&#x20;

We will provisionally assign a release based on discussion with you when you commence development.  The release is confirmed when your pull-request is code reviewed and merged ready for UAT testing.  If code review is not completed before the "code freeze" deadline for a release, then your pull request will be moved to the next available release.



### Contribution Champions!

The following developers from our global community deserve extra special kudos for already contributing critical features to OpenCRVS following the process above. &#x20;

We are hugely grateful to you for your contributions.

> _Bug fixing and developing new features can be quite challenging, especially when you're new to OpenCRVS. Thankfully, the core team and other contributors are always there to guide you, offering ideas and recommendations to help you make it work. I’m grateful for the chance to learn and grow through open collaboration, and I’m looking forward to contributing more. -_ [_Onion Quimson_](https://github.com/oni-on1003) _- Philippines_

| Github Profile                                                               | Country                                      | Feature                                        |
| ---------------------------------------------------------------------------- | -------------------------------------------- | ---------------------------------------------- |
| [https://github.com/oni-on1003](https://github.com/oni-on1003)               | Philippines                                  | New Form UI Components                         |
| [https://github.com/Eezi](https://github.com/Eezi)                           | Finland                                      | DevOps Optimisations                           |
| [https://github.com/ak-shanith](https://github.com/ak-shanith)               | [Bevolv](https://www.bevolv.co/) - Sri Lanka | MOSIP Integration, Interoperability & Bugfixes |
| [https://github.com/anjana6](https://github.com/anjana6)                     | [Bevolv](https://www.bevolv.co/) - Sri Lanka | MOSIP Integration, Interoperability & Bugfixes |
| [https://github.com/PathumN99](https://github.com/PathumN99)                 | [Bevolv](https://www.bevolv.co/) - Sri Lanka | MOSIP Integration, Interoperability & Bugfixes |
| [https://github.com/Hyper3x](https://github.com/Hyper3x)                     | [Bevolv](https://www.bevolv.co/) - Sri Lanka | MOSIP Integration, Interoperability & Bugfixes |
| [https://github.com/tharakadadigama20](https://github.com/tharakadadigama20) | [Bevolv](https://www.bevolv.co/) - Sri Lanka | MOSIP Integration, Interoperability & Bugfixes |

