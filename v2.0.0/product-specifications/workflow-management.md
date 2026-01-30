---
metaLinks:
  alternates:
    - >-
      https://app.gitbook.com/s/RziAMaeBMeyiTg5hfFq5/product-specifications/workflow-management
---

# Workflow management

## Workqueues

Declarations are organised in each Registration Office into separate work queues based so they can easily prioritise and manage their workload.\
\
Workqueues are configurable for each user role allowing you to configure custom record workflows

For a comprehensive understanding of the various statuses and the potential pathways a record can follow, please refer to the [status-flow-diagram.md](status-flow-diagram.md "mention")\
\
The following example workqueues have been configured for Farajaland:

### Draft

Shown if a user has `scope:record.create[event=event]` . To list all saved draft declarations

### **Notifications**

To list all notifications sent by a user or external system eg. a health system.

### Sent for review

To list all declarations that have been notified or declared by the user

### Ready for review

To list all declarations that are ready for review, potential duplicates or a correction has been requested

### **Requires updates**

To list all records that were rejected

### **Sent for approval**

To list all records validated by the user

### **Ready to print**

To list all recently registered records which have not been certified.

***

## Outbox

This workqueue is for the system to process status changes to a record. It provides all users with the freedom to continue creating and reviewing declarations without the constraint of a stable internet connection, thereby ensuring a consistent and uninterrupted workflow.

For instance, Field Agents have the ability to create declarations offline. Once internet connectivity is reestablished, the Outbox automatically synchronises these offline declarations with the server, forwarding them to the Registration Office. Likewise, a Registration Agent can review a declaration offline, send it for approval, and promptly proceed to review another declaration that they have pre-allocated.

The Outbox instills a sense of confidence among users by securely storing declarations, ensuring they are processed promptly upon reconnection to the internet. This feature effectively mitigates the risk of losing valuable data due to intermittent connectivity, providing users with peace of mind.

## Assigning records

When a user assigns a declaration to themselves, it is download to their device, allowing them to perform actions offline such as making updates and reviewing. This precautionary measure prevents potential conflicts that could arise if two users attempt to edit the same record concurrently.

When a record is assigned to a user, its ‘assigned’ status becomes visible to other system users in the workqueues, indicated using their profile icon. Only a Registrar possesses the authority to unassign a user from a record. However, executing this action will result in the loss of any modifications made by the assigned user.

In conjunction with the Outbox, this assignment feature fosters a resilient system, well-equipped to support operations in low-connectivity or offline scenarios.
