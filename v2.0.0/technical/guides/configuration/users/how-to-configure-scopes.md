# How to configure scopes

Scopes are the mechanism that grants users access to perform role-specific actions. At a high level, a scope has two properties:

* **Type** — which action the user can take with the scope (e.g. `record.create`, `record.read`, `user.create`).
* **Options** — the limitations under which the action can be performed (e.g. a user can only search birth events that took place in their administrative area: `{ type: 'record.search', options: { event: ['birth'], placeOfEvent: 'administrativeArea' } }`).

\
To perform actions, a user must be assigned to a role with appropriate scopes. You can find the [available scopes here](https://github.com/opencrvs/opencrvs-core/blob/v2.0.0-beta/packages/commons/src/scopes.ts).

\
To get started, let's [look at the example configuration](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/data-seeding/roles/roles.ts). `opencrvs-core`  exposes a helper for defining scopes, and provides type information.



Example:  scope that allows user to search for **birth** records which took place within their **administrative area.**&#x20;

* [Learn what administrative areas are](../administrative-hierarchy/administrative-areas.md)
* [Learn how to configure place of event](../administrative-hierarchy/how-to-configure-place-of-event.md)

```
import { defineScopes } from '@opencrvs/toolkit/scopes'
const scopes = defineScopes([{
    type: 'record.search',
    options: {
        event: ['birth'],
        placeOfEvent: 'administrativeArea'
    }
}]) // ['type=record.search&placeOfEvent=administrativeArea&event=birth']
```

\
Scopes are encoded as query strings and included in the JWT provided at user login. The token is passed around the system, and user access is determined by its scope contents.

**Example: JWT payload for the example user**

```
{
  "scope": [
    "type=record.search&placeOfEvent=administrativeArea&event=birth",
  ],
  "userType": "user",
  "role": "REGISTRATION_AGENT",
  "iat": 1778663757,
  "exp": 1779268557,
  "aud": [
    "opencrvs:events-user",
  ],
  "iss": "opencrvs:auth-service",
  "sub": "783a5bbc-d0f0-4fce-a65e-2afc868d2e41"
}
```

### How scope options are evaluated

\
**Example 1: Single scope**

```
const scopes = defineScopes([{ 
  type: 'record.search', 
  options: { event: ['birth'], placeOfEvent: 'administrativeArea' }
}])

const registrationAgent = {
    "id": "783a5bbc-d0f0-4fce-a65e-2afc868d2e41",
    "role": "REGISTRATION_AGENT",
    // primaryOfficeId accepts only locations.
    "primaryOfficeId": "69b627cc-8e4d-45f3-8eb9-45536c4838c6",
    "administrativeAreaId": "18c5b1a3-49e5-4ff8-8096-8c856575e6d0",
}

const birthEvent = {
  "id": "590221bc-9419-4b51-80dd-3a1a2c31899f",
  "type": "birth",
  "status": "DECLARED",
  "placeOfEvent": [
    "9e93fbbb-a904-4d5e-ac0b-f77b969b964f",
    "18c5b1a3-49e5-4ff8-8096-8c856575e6d0",
    "f7461bf7-b6d9-436a-a66d-5191e6ef6586"
  ]
}

const deathEvent = {
  "id": "590221bc-9419-4b51-80dd-3a1a2c31899f",
  "type": "death",
  "status": "DECLARED",
  "placeOfEvent": [
    "9e93fbbb-a904-4d5e-ac0b-f77b969b964f",
    "18c5b1a3-49e5-4ff8-8096-8c856575e6d0",
    "69b627cc-8e4d-45f3-8eb9-45536c4838c6"
  ]
}
```

* :white\_check\_mark:  `registrationAgent` **can** access `birthEvent` — `placeOfEvent` includes their `administrativeAreaId`, and the event type matches `event: ['birth']` in their scope. &#x20;
* :x:  `registrationAgent` **cannot** access `deathEvent` — `placeOfEvent` includes their `administrativeAreaId`, but the event type does not match `event: ['birth']` in their scope.

{% hint style="info" %}
Scope options are combined using AND. For access to be granted, all of the conditions defined in the options must be met.
{% endhint %}

### Using multiple scopes for the same scope type

Sometimes access conditions are too complex to define with a single scope. You can provide multiple scopes for the same type — these are combined using OR, meaning it is sufficient for one scope to match completely.

**Example 2: Two scopes for the same type**

```
const registrationAgentScopes = defineScopes([
{ type: 'record.search', options: { event: ['birth'], placeOfEvent: 'administrativeArea' } }
{ type: 'record.search', options: { event: ['death'], placeOfEvent: 'location' } }
])

const registrationAgent = {
    "id": "783a5bbc-d0f0-4fce-a65e-2afc868d2e41",
    "role": "REGISTRATION_AGENT",
    "primaryOfficeId": "69b627cc-8e4d-45f3-8eb9-45536c4838c6",
    "administrativeAreaId": "18c5b1a3-49e5-4ff8-8096-8c856575e6d0",
}

const birthEvent = {
  "id": "590221bc-9419-4b51-80dd-3a1a2c31899f",
  "type": "birth",
  "status": "DECLARED",
  "placeOfEvent": [
    "9e93fbbb-a904-4d5e-ac0b-f77b969b964f",
    "18c5b1a3-49e5-4ff8-8096-8c856575e6d0",
    "f7461bf7-b6d9-436a-a66d-5191e6ef6586"
  ]
}

const deathEvent = {
  "id": "590221bc-9419-4b51-80dd-3a1a2c31899f",
  "type": "death",
  "status": "DECLARED",
  "placeOfEvent": [
    "9e93fbbb-a904-4d5e-ac0b-f77b969b964f",
    "18c5b1a3-49e5-4ff8-8096-8c856575e6d0",
    "69b627cc-8e4d-45f3-8eb9-45536c4838c6"
  ]
}
```

* :white\_check\_mark:  `registrationAgent` **can** access `birthEvent` — `placeOfEvent` includes their `administrativeAreaId`, and the event type matches `event: ['birth']` in the first scope.  &#x20;
* :white\_check\_mark:  `registrationAgent` **can** access `deathEvent` — `placeOfEvent` includes their `primaryOfficeId`, and the event type matches `event: ['death']` in the second scope.



<br>

