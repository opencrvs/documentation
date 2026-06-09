# How to limit location and administrative area options in event declaration

Scopes serve two purposes: keeping the system secure by granting only the necessary access, and making declarations easy and intuitive to fill in. In this example, a `HOSPITAL_CLERK` can only declare births at their own location.

&#x20;[See other roles to help you configure your own.](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/data-seeding/roles/roles.ts#L199)\
\
**Example: `HOSPITAL_CLERK`** <br>

**Step 1: Configure the role**

```
  const hospitalClerk = {
    id: 'HOSPITAL_CLERK',
    label: {
      defaultMessage: 'Hospital Official',
      description: 'Name for user role Hospital Official',
      id: 'userRole.hospitalClerk'
    },
    scopes: defineScopes([
      { type: 'record.create', options: { placeOfEvent: 'location' } },
      { type: 'record.read', options: { placeOfEvent: 'location' } },
      { type: 'record.declare', options: { placeOfEvent: 'location' } },
      { type: 'record.notify', options: { placeOfEvent: 'location' } },
    ])
  }
```

**Step 2: Configure the event form**

[See the full event example for context.](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/events/birth/forms/pages/child.ts)

<pre><code><strong>// 1. Other dropdown options are not shown for the HOSPITAL_CLERK. Only HEALTH_FACILITY is visible.
</strong>const placeOfBirthOptions = [
  {
    value: PlaceOfBirth.HEALTH_FACILITY,
    label: placeOfBirthMessageDescriptors.HEALTH_FACILITY,
    ]
  },
  {
    value: PlaceOfBirth.PRIVATE_HOME,
    label: placeOfBirthMessageDescriptors.PRIVATE_HOME,
    conditionals: [
      {
        type: ConditionalType.SHOW,
        conditional: not(user.hasRole('HOSPITAL_CLERK'))
      }
    ]
  },
  {
    value: PlaceOfBirth.OTHER,
    label: placeOfBirthMessageDescriptors.OTHER.defaultMessage,
    conditionals: [
      {
        type: ConditionalType.SHOW,
        conditional: not(user.hasRole('HOSPITAL_CLERK'))
      }
    ]
  }
] satisfies SelectOption[]

// 2. Configure select with options.
const child =  {
    id: 'child.placeOfBirth',
    type: FieldType.SELECT,
    options: placeOfBirthOptions
  },
    // 3. Configure 
    {
      id: 'child.birthLocation',
      type: FieldType.LOCATION,
      // 4. Field is only shown when HEALTH_FACILITY is selected.
      conditionals: [
        {
          type: ConditionalType.SHOW,
          conditional: field('child.placeOfBirth').isEqualTo(
            PlaceOfBirth.HEALTH_FACILITY
          )
        }
      ],
      configuration: {
      // 5. By default any type of location is included. Now we filter by "HEALTH_FACILITY" type
        locationTypes: ['HEALTH_FACILITY'],
        // 6. Another filter which further limits options only to what user's record.scope has.
        allowedLocations: user.jurisdiction(
          user.scope('record.create').attribute('placeOfEvent')
        )
      }
    }
</code></pre>

<div><figure><img src="../../../../.gitbook/assets/Screenshot 2026-05-22 at 9.52.05.png" alt=""><figcaption></figcaption></figure> <figure><img src="../../../../.gitbook/assets/Screenshot 2026-05-22 at 9.51.50.png" alt=""><figcaption></figcaption></figure></div>

