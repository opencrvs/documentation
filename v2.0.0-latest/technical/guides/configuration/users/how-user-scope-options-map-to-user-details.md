# How "user scope" options map to user details?

### Managing users

\
In production environments, users are created manually by other users. The locations where a new user can be placed, and the roles they can be assigned, are controlled by the creating [user's scopes.](https://github.com/opencrvs/opencrvs-core/blob/v2.0.0-beta/packages/commons/src/scopes.ts#L250)

**Example: `LOCAL_SYSTEM_ADMIN` creating or editing another user**

```
  const localSystemAdmin = {
    id: 'LOCAL_SYSTEM_ADMIN',
    label: {
      defaultMessage: 'Administrator',
      description: 'Name for user role Administrator',
      id: 'userRole.administrator'
    },
    scopes: defineScopes([
        { type: 'user.create', options: { accessLevel: 'administrativeArea', role: ['HOSPITAL_CLERK', 'COMMUNITY_LEADER', 'REGISTRATION_AGENT', 'LOCAL_REGISTRAR', 'PROVINCIAL_REGISTRAR'] } },
        { type: 'user.edit', options: { accessLevel: 'administrativeArea', role: ['HOSPITAL_CLERK', 'COMMUNITY_LEADER', 'REGISTRATION_AGENT', 'LOCAL_REGISTRAR', 'PROVINCIAL_REGISTRAR'] } },
        { type: 'user.read', options: { accessLevel: 'administrativeArea' } },
        { type: 'user.search', options: { accessLevel: 'administrativeArea' } }
      ])
  },
```

1. **Role selection** is limited to the roles defined in the `user.create` and `user.edit` scopes.

<figure><img src="../../../../.gitbook/assets/Screenshot 2026-05-22 at 14.39.37.png" alt="" width="375"><figcaption></figcaption></figure>

2. **Available locations** are limited to those within the `LOCAL_SYSTEM_ADMIN`'s administrative area. [See how scopes relate to jurisdictions](roles-and-scopes.md).

<figure><img src="../../../../.gitbook/assets/Screenshot 2026-05-22 at 14.41.37.png" alt="" width="375"><figcaption></figcaption></figure>

3. **Editing restrictions** — the editor must have scope coverage over the edited user's location and role, both before and after any change. This prevents an editor from moving a user outside their own jurisdiction.
