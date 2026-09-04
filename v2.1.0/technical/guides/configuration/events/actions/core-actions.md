---
description: Configuring core actions
---

# Core actions

At a basic level, [event is a document](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/commons/src/events/EventDocument.ts), consisting of an [ordered list of actions](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/commons/src/events/ActionDocument.ts). The actions determine [the state of the event](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/commons/src/events/EventIndex.ts#L23). Depending on the state, different actions are available. For example, event needs to be declared before it can be registered. By the same token, event cannot be declared after it has been registered.

OpenCRVS provides a set of [core actions](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/commons/src/events/ActionType.ts) which are recognised and supported at system level. Apart from `CREATE`, each of the actions needs to be configured in the [event configuration](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/commons/src/events/EventConfig.ts).

Since core actions are defined by the system, they are only partially configurable by the system implementor. [What is configurable](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/commons/src/events/ActionConfig.ts) depends on the action type.

### Status determines available actions

[Available actions are based on the status of the event.](https://github.com/opencrvs/opencrvs-core/blob/develop/packages/commons/src/events/state/availableActions.ts) \
\
1\. An event always has a status. The status of the event is based on the actions that have been performed previously.

```typescript
export const EventStatus = z.enum([
  'CREATED',
  'NOTIFIED',
  'DECLARED',
  'REGISTERED',
  'ARCHIVED'
])
```

2. Statuses follow each other. Some state changes are not possible after certain point. For example, a `DECLARED` event cannot be deleted, nor can a `REGISTERED` archived.

<figure><img src="../../../../../.gitbook/assets/Screenshot 2026-08-31 at 12.58.04.png" alt=""><figcaption><p>Status changes follow successful actions. Some actions are optional. They do not need to occur for the event to be registered.</p></figcaption></figure>



### Actions gather and provide information

The goal of the event configuration is to gather all the necessary information for the event to be `REGISTERED`. Once the event is registered, we can be certain that the country-defined process has been followed, and further actions, like `PRINT_CERTIFICATE`, are based on verified information.

{% hint style="info" %}
Action-specific form configurations are part of annotation in the corresponding `ActionDocument`&#x20;
{% endhint %}

<pre class="language-typescript"><code class="lang-typescript"><a data-footnote-ref href="#user-content-fn-1">export const ActionDocument = z.object({</a>
  declaration: ActionUpdate.describe('Declaration data defined by the EventConfig. Supports partial updates.'),
  annotation: ActionUpdate.optional().nullable().describe('Action-specific metadata. Actions are independently configurable.'),
  content: z.object().nullable().describe('Action-specific metadata. System configured.')
  // ---METADATA common to all actions---
  createdAt: z.string().datetime().describe('Timestamp indicating when the action was created.'),
  createdBy: z.string().describe('Identifier of the user who created the action.'),
  ...,
// --- METADATA common to all actions---
})

// Example 1. "READ" action has only mandatory data.
const ReadActionDocument = {
  type: 'READ',
  declaration: {},
  annotation: null,
  createdAt: "2026-08-31T08:30:55.604Z",
  createdBy: "ea3e4480-2263-40e8-937c-463a9260b729",
}

// Example 2. "DECLARE" action has both declaration and annotation based on the configuration.
const DeclarationActionDocument = {
  type: 'DECLARE',
  declaration: {
    "applicant.dob": "2026-08-31",
    "applicant.tob": "11:54",
    "applicant.name": {
      "surname": "Mweene",
      "firstname": "Kennedy",
      "middlename": "Ewe",
  },
  annotation: {
    "review.comment": "My comment",
    "review.signature": {
      "path": "f78b5b6f-41a5-4007-b3a1-85704f28966c.png",
      "type": "image/png",
      "originalFilename": "signature-1779281690594.png"
    }
  },
  createdAt: "2026-08-31T08:30:55.604Z",
  createdBy: "ea3e4480-2263-40e8-937c-463a9260b729",
 }
}

// Example 3. "PRINT_CERTIFICATE" action has both annotation and content.
// Annotation is based on ActionConfig and different from DECLARE's annotation.
// content is specified by the system.
const PrintCertificateActionDocument = {
  type: 'PRINT_CERTIFICATE',
  declaration: {},
  annotation: {
   "collector.requesterId": "OTHER",
   "collector.OTHER.relationshipToChild": "UNCLE",
  },
  content: {
    "templateId": "v2.birth-certificate"
  },
  createdAt: "2026-08-31T08:30:55.604Z",
  createdBy: "ea3e4480-2263-40e8-937c-463a9260b729",
}

// Example 4: "DUPLICATE_DETECTED" action has "content 
// Action is triggered by declaration action ('DECLARE', 'NOTIFY' and similar) and managed by the system.
const DuplicateDetectedActionDocument = {
  type: 'DUPLICATE_DETECTED',
  declaration: {},
  annotation: null,
  content: {
    duplicates: [{
        "id": "3c6cfa5e-033b-4549-8064-7c4fa692185b",
        "trackingId": "GPOZZ2"
      }]
  },
  createdAt: "2026-08-31T08:30:55.604Z",
  // Determined by whose action triggered the duplicate detection.
  createdBy: "ea3e4480-2263-40e8-937c-463a9260b729",
}



</code></pre>

#### Configuring action annotations

{% hint style="info" %}
Action configuration forms are independent but they can use shared fields.
{% endhint %}

Example 1: `DECLARE` defines two fields, shown on the action review page.

```typescript
{
  type: ActionType.DECLARE,
  label: {
    defaultMessage: "Declare",
    description:
      "This is shown as the action name anywhere the user can trigger the action from",
    id: "event.example-event.action.declare.label",
  },
  // Specifies additional fields shown in declaration review page.
  // Output is persisted as declare's ActionDocument annotation.
  review: {
    title: {
      id: "event.my-example.action.declare.form.review.title",
      defaultMessage: "Title",
      description: "Title of the review page",
    },
    fields: [
      {
        id: "review.comment",
        type: "FieldType.TEXTAREA",
        label: {
          defaultMessage: "Comment",
          id: "event.my-example.action.declare.form.review.comment.label",
          description: "Label for the comment field in the review section",
        },
      },
      {
        type: "FieldType.SIGNATURE",
        id: "review.signature",
        label: {
          defaultMessage: "Signature of informant",
          id: "event.my-example.action.declare.form.review.signature.label",
          description: "Label for the signature field in the review section",
        },
        signaturePromptLabel: {
          id: "signature.upload.modal.title",
          defaultMessage: "Draw signature",
          description: "Title for the modal to draw signature",
        },
      },
    ],
  },
};
```

<figure><img src="../../../../../.gitbook/assets/Screenshot 2026-08-31 at 16.04.00.png" alt="" width="375"><figcaption><p>Comment and signature fields rendered based on the review configuration</p></figcaption></figure>

Example 2: `PRINT_CERTIFICATE` configures complete form with two fields:

```typescript
{
  type: "ActionType.PRINT_CERTIFICATE",
  label: {
    defaultMessage: "Print certificate",
    description:
      "This is shown as the action name anywhere the user can trigger the action from",
    id: "event.my-example.action.collect-certificate.label",
  },
  printForm: {
    label: {
      id: "event.my-example.action.certificate.form.label",
      defaultMessage: "Example event certificate form",
      description: "This is what this form is referred as in the system",
    },
    pages: [
      {
        id: "collector",
        type: PageTypes.enum.FORM,
        fields: [
          {
            id: "collector.requesterId",
            type: "SELECT",
            required: true,
            label: {
              defaultMessage: "Requester",
              description: "This is the label for the field",
              id: "event.my-example.action.certificate.form.section.requester.label",
            },
            options: [
              {
                label: {
                  id: "event.my-example.action.certificate.form.section.requester.informant.label",
                  defaultMessage: "Print and issue Informant",
                  description: "This is the label for the field",
                },
                value: "INFORMANT",
              },
              {
                label: {
                  id: "event.my-example.action.certificate.form.section.requester.other.label",
                  defaultMessage: "Print and issue someone else",
                  description: "This is the label for the field",
                },
                value: "OTHER",
              },
            ],
          },
          {
            id: "collector.OTHER.relationshipToMember",
            type: "TEXT",
            required: true,
            label: {
              defaultMessage: "Relationship to Member",
              description:
                "This is the label for the relationship to member field",
              id: "event.my-example.action.form.section.relationshipToMember.label",
            },
            conditionals: [
              {
                type: ConditionalType.SHOW,
                conditional: field("collector.requesterId").inArray(["OTHER"]),
              },
            ],
          },
        ],
      },
    ],
  },
};

```

&#x20;



<figure><img src="../../../../../.gitbook/assets/Screenshot 2026-08-31 at 15.54.46.png" alt="" width="563"><figcaption><p><code>PRINT_CERTIFICATE</code> action specifies another form and the results are part of the annotation.</p></figcaption></figure>

1. `annotation` fields are inside red box. Defined in `ActionConfig`&#x20;
2. `content` fields inside blue box. Defined outside `ActionConfig`



{% openapi-schemas spec="events-develop" schemas="ReadActionConfig,DeclareActionConfig,EditActionConfig,RejectActionConfig,RegisterActionConfig,PrintCertificateActionConfig,RequestCorrectionActionConfig,ArchiveActionConfig,UnarchiveActionConfig" grouped="true" %}
[OpenAPI events-develop](https://api.opencrvs.org/develop/events/openapi.yml)
{% endopenapi-schemas %}

[^1]: Partial ActionDocument with relevant fields only.
