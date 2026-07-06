# Roles and scopes

Each user has an assigned role. A role determines which actions the user can take. Scopes are the mechanism that grants users access to perform role-specific actions. Learn [more about scopes here](how-to-configure-scopes.md)

At a high level, a scope has two properties:

* **Type** — which action the user can take with the scope (e.g. `record.create`, `record.read`, `user.create`).
* **Options** — the limitations under which the action can be performed (e.g. a user can only search birth events that took place in their administrativeArea: `{ type: 'record.search', options: { event: ['birth'], placeOfEvent: 'administrativeArea' } }`).

A user is always assigned to a location. The location's position in the administrative hierarchy determines the jurisdiction the scope grants. Learn [how to configure place of event](../administrative-hierarchy/how-to-configure-place-of-event.md).\
\
**Example 1: Jurisdiction based on administrative area** `{ placeOfEvent: 'administrativeArea' }`&#x20;

<figure><img src="../../../../.gitbook/assets/Screenshot 2026-05-11 at 15.12.06.png" alt=""><figcaption></figcaption></figure>

The dotted lines illustrate jurisdiction. An `administrativeArea` scope covers the administrative area itself, all locations within it, and all descending areas.

\
**Example 2: Jurisdiction based on location** — `{ placeOfEvent: 'location' }`

<figure><img src="../../../../.gitbook/assets/Screenshot 2026-05-14 at 13.57.27.png" alt=""><figcaption></figcaption></figure>

A location scope limits the user to a single location. For example, users in District Hospital A with scope `{ type: 'record.read', placeOfEvent: 'location' }` will only see events from District Hospital A. Events from District Hospital B and C would only be visible with the `{ placeOfEvent: 'administrativeArea' }` option.



**Example 3: Different roles directly under country**

<figure><img src="../../../../.gitbook/assets/Screenshot 2026-05-14 at 14.17.03.png" alt=""><figcaption></figcaption></figure>

In cases such as an embassy, it is safer to create a separate role with more limited scopes. If the same roles are reused, locations outside the country will inherit the same jurisdiction as HQ Office by default.

