# Workflow management

## Workqueues

Declarations are organised in each Registration Office into separate work queues based on their status, such as "In Progress," "Ready for Review" and "Ready to Print" so users can easily prioritise and manage their workload.

For a comprehensive understanding of the various statuses and the potential pathways a record can follow, please refer to the [status-flow-diagram.md](status-flow-diagram.md "mention")

### **Field Agent:**

#### **In progress**

If a declaration is started and then saved as a draft, it will appear in this work queue. These declarations are stored locally on the mobile device or computer, which means other office users will not see these draft declarations.

Record status: In progress

#### **Sent for review**

This workqueue displays incomplete or complete declaration sent to a registration office.

When a declaration is ‘Certified’, ‘Issued’ or ‘Archived’ by the Registration office and the Field Agent has an internet connection then the declaration is removed from their Sent for Review workqueue.

Record status: In progress, In review, Registered

#### **Requires updates**

This workqueue displays declarations send for updates by a Registration Agent or Registrar. Currently the Field Agents is unable to update the declaration. This feature is intended solely to support any queries made by the informant. When a declaration is ‘Certified’, ‘Issued’ or ‘Archived’ by the Registration office and the Field Agent has an internet connection then the declaration is removed from their Requires updates workqueue.

Record status: Requires updates

### Registration **Agent:**

#### **In progress**

1.  **Yours**

    If a declaration is started and then saved as a draft, it will appear in this work queue. These declarations are stored locally on the mobile device or computer, which means other office users will not see these draft declarations.
2.  **Field Agents**

    This workqueue tab displays incomplete declaration sent by a Field Agent
3.  **Health system**

    This workqueue tab displays health notifications sent by an integrated health system

Record status: In progress

#### **Ready for review**

This work queue displays declarations that have been sent for complete review, including all mandatory information provided by a Field Agent.

Record status: In review

#### **Requires updates**

This workqueue displays declarations sent for updates.

Record status: Requires updates

#### **Sent for approval**

This workqueue displays declarations sent for approval by the Registration Agent.

Record status: Validated

#### **Ready to print**

This workqueue displays all recently registered records which have not been certified.

Record status: Registered

#### **Ready to issue**

This workqueue displays records that have been certified in advance of issuance

Record status: Certified

### Registrar

#### **In progress**

1.  **Yours**

    If a declaration is started and then saved as a draft, it will appear in this work queue. These declarations are stored locally on the mobile device or computer, which means other office users will not see these draft declarations.
2.  **Field Agents**

    This workqueue tab displays incomplete declaration sent by a Field Agent
3.  **Health system**

    This workqueue tab displays health notifications sent by an integrated health system

Record status: In progress

#### **Ready for review**

This work queue displays declarations that have been sent for complete review, including all mandatory information provided by a Field Agent. In addition, declaration validated and sent for approval by a Registration Agent.

Record status: In review, Validated

#### **Requires updates**

This workqueue displays declarations sent for updates.

Record status: Requires updates

#### **Ready to print**

This workqueue displays all recently registered records which have not been certified.

Record status: Registered

#### **Ready to issue**

This workqueue displays records that have been certified in advance of issuance

Record status: Certified

## Outbox

This workqueue is for the system to process status changes to a record. It provides all users with the freedom to continue creating and reviewing declarations without the constraint of a stable internet connection, thereby ensuring a consistent and uninterrupted workflow.

For instance, Field Agents have the ability to create declarations offline. Once internet connectivity is reestablished, the Outbox automatically synchronises these offline declarations with the server, forwarding them to the Registration Office. Likewise, a Registration Agent can review a declaration offline, send it for approval, and promptly proceed to review another declaration that they have pre-allocated.

The Outbox instills a sense of confidence among users by securely storing declarations, ensuring they are processed promptly upon reconnection to the internet. This feature effectively mitigates the risk of losing valuable data due to intermittent connectivity, providing users with peace of mind.

## Assigning records

When a user assigns a declaration to themselves, it is download to their device, allowing them to perform actions offline such as making updates and reviewing. This precautionary measure prevents potential conflicts that could arise if two users attempt to edit the same record concurrently.

When a record is assigned to a user, its ‘assigned’ status becomes visible to other system users in the workqueues, indicated using their profile icon. Only a Registrar possesses the authority to unassign a user from a record. However, executing this action will result in the loss of any modifications made by the assigned user.

In conjunction with the Outbox, this assignment feature fosters a resilient system, well-equipped to support operations in low-connectivity or offline scenarios.
