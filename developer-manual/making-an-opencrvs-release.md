# Making an OpenCRVS Release

## Our publish release workflows are not perfect yet so these are the steps to follow to publish a release

1. Core & Countryconfig: Update **ALL package.json's versions...**:

```json
"version": "1.5.0",

&

"@opencrvs/commons": "^1.5.0",
"@opencrvs/components": "^1.5.0" // if UI changes made

```

2. **AND** this hardcoded string in client...

```typescript
export const APPLICATION_VERSION = 'v1.5.0'
```

3\. Update the default image tag in workflows e.g. deploy.yml

```yaml
default: 'v1.5.0'
```

4. Update [storybook release](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/components/stories/releases.stories.mdx)
5. Run Core Publish Release workflow (tags and pushes docker images)
6. Create tag in core and country config:

```
git tag v1.5.0
git push origin v1.5.0
```

6. Push countryconfig image to Dockerhub manually (Publish release workflow wont run properly from a release branch)

```
export COUNTRY_CONFIG_VERSION=$(git describe --tags --exact-match 2>/dev/null || git rev-parse --short=7 HEAD)
echo $COUNTRY_CONFIG_VERSION
bash build-and-push.sh
unset COUNTRY_CONFIG_VERSION
```

7. Merge release branches into master branch - DONT SQUASH & MERGE
8. Core create a \[new release on Github]\(https://github.com/opencrvs/opencrvs-core/releases) using the tag you just pushed and including any release notes. . Generate release notes at the end for the Commit links and changelog. Check latest release
9. Countryconfig create a \[new release on Github]\(https://github.com/opencrvs/opencrvs-countryconfig/releases) using the tag you just pushed and including any release notes. . Generate release notes at the end for the Commit links and changelog. Check latest release
10. Core: Create a Github discussion for the release
11. Immediately make the next release or hotfix branch so that we can continue with new development on develop
12. **DONE!** :clap:&#x20;

