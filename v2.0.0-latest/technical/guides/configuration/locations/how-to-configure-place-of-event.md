# How to configure place of event

## Where do events take place?

Each event has a `placeOfEvent` property in its indexed format (`EventIndex`). All jurisdiction questions are resolved against this property. `placeOfEvent` is a metadata field that defaults to the user's location.

For some events, it may be more appropriate to specify a different field to determine where the event took place. This [field is defined at the root of the event configuration.<br>](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/events/birth/index.ts#L49)

### Field types for `placeOfEvent`

`placeOfEvent` accepts both administrative area and location field types as reference values.

**Example: Birth event**

Relying on the default behaviour — using the user's location as the `placeOfEvent` value — works in some cases:

* A hospital clerk assigned to the hospital where the birth took place. :white\_check\_mark:
* An office worker declaring the birth with the informant at the office. :x:

Since a birth can happen anywhere, relying solely on locations available in the system may be insufficient. An alternative is to use the `Address` field type, which allows dynamic configuration of an exact address. In this case, `placeOfEvent` takes the most precise administrative area as its value, allowing the system to still use `placeOfEvent` to determine user jurisdiction.\
\
**Fallback behaviour**

| Scenario                                                         | `placeOfEvent` value |
| ---------------------------------------------------------------- | -------------------- |
| No explicit `placeOfEvent` defined in config                     | User's location      |
| Explicit `placeOfEvent` defined, but empty in the declaration    | User's location      |
| Explicit `placeOfEvent` defined and submitted in the declaration | Value from the field |



#### Using multiple fields for `placeOfEvent`

As of OpenCRVS v2.0, `placeOfEvent` does not directly support arrays.

In the [example birth event](https://github.com/opencrvs/opencrvs-countryconfig/blob/release-v2.0.0/src/events/birth/forms/pages/child.ts#L438), the form renders different fields based on the `SELECT` field `child.placeOfBirth`.

The following shows the available options for birth location and how `placeOfEvent` is configured to reference a single field:

```
{
  placeOfEvent: field('child.birthLocationId')
}
```

\
The `birthLocationId` field, of type `ALPHA_HIDDEN`, is an invisible field that can take an array of field references as its value:

{% hint style="info" %}
Note: `ALPHA_HIDDEN` is alpha version. This means we might not support it in the future, or we may introduce breaking changes in the future.
{% endhint %}

```typescript
    {
      id: 'child.birthLocationId',
      type: FieldType.ALPHA_HIDDEN,
      required: false,
      label: {
        defaultMessage: 'Health Institution',
        description: 'This is the label for the field',
        id: 'event.birth.action.declare.form.section.child.field.birthLocation.label'
      },
      parent: [
        field('child.placeOfBirth'),
        field('child.birthLocation'),
        field('child.birthLocation.privateHome'),
        field('child.birthLocation.other')
      ],
      value: [
        field('child.birthLocation'),
        field('child.birthLocation.privateHome').get('administrativeArea'),
        field('child.birthLocation.other').get('administrativeArea')
      ]
    },
```

`placeOfEvent` receives the first visible value, so it is important to configure the declaration form so that only one field option is rendered at a time.

\
<img src="../../../../.gitbook/assets/Screenshot 2026-05-14 at 13.41.30.png" alt="" data-size="original">\
<sub>Rendered options for birth location</sub>

