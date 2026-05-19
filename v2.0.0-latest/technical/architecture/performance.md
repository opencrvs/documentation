---
description: >-
  OpenCRVS is built to run national-scale civil registration systems. This page
  explains what that means in practice — how many people can use it, how fast it
  responds, and how it handles pressure.
---

# Performance

All numbers on this page come from load tests run against a database of **1.2 million records** on a modest two-server setup. A larger deployment would perform even better.

***

### At a glance

|                           |                                                     |
| ------------------------- | --------------------------------------------------- |
| **Simultaneous users**    | 1,000+ logged-in users at the same time             |
| **Registration speed**    | Under 350 ms to process a birth registration        |
| **Search speed**          | Under 60 ms to return search results                |
| **Error rate under load** | 0.00%                                               |
| **Spike recovery**        | Returns to normal within seconds of a traffic surge |

***

### How many people can use it at once?

In testing, OpenCRVS supported **over 1,000 users working simultaneously** — registrars filling in forms, staff searching for records, and supervisors monitoring workqueues — with every operation completing well within acceptable time limits.

To put that in context: even in a country the size of the Philippines (\~117 million people), it's unusual for more than a few hundred staff to be actively submitting registrations at the exact same moment. The system has significant headroom beyond typical peak demand.

These tests simulated realistic user behaviour, including time spent reading screens, filling in forms, and the background polling that the OpenCRVS client performs automatically. The number of virtual users in the test directly represents the number of real people who could be logged in and working at the same time.

### How fast is it?

Response times are measured server-side — the time it takes the server to process a request, not including network travel time between the user's device and the server.

| What a user does            | How long the server takes |
| --------------------------- | ------------------------- |
| Log in                      | \~130 ms                  |
| Submit a birth registration | \~150 ms                  |
| Complete a registration     | \~170 ms                  |
| Search for a record         | \~25 ms                   |
| Open a record               | \~75 ms                   |
| Load the workqueue          | \~30 ms                   |

For comparison, a typical web page takes 1–3 seconds to load. These server processing times are a fraction of that — most operations feel instant to the user.

### What happens during a traffic spike?

We tested what happens when demand suddenly jumps to **five times the normal level** — as might happen on a Monday morning, after a public holiday, or during a registration campaign.

The system handled the spike with no crashes, no errors, and no data loss. When the spike ended, response times returned to normal within seconds. There were no lingering effects — no stuck processes, no degraded performance for subsequent users.

### How big can the database get?

The test database contained **1.2 million event records** — roughly six months of registration data for a country of 100–120 million people. At this scale, searches still returned results in under 60 ms and registrations completed in under 350 ms.

For reference, a country registering 10,000 events per day would accumulate about 3.6 million records per year. Database maintenance strategies such as indexing and archival are available to maintain performance as the dataset grows over multiple years.

### What infrastructure does it need?

The test results above were achieved on a deliberately modest setup:

| Server    | Specification             |
| --------- | ------------------------- |
| Primary   | 8 CPU cores, 16 GB memory |
| Secondary | 4 CPU cores, 8 GB memory  |

This is a baseline configuration. National deployments can scale infrastructure up or horizontally to increase capacity further. Even on this small setup, the system never used more than half its available memory and experienced zero crashes or restarts.

### What about the user's device?

The performance numbers above measure **server-side speed only**. The experience on a user's device also depends on their internet connection, browser, and device capability.

One known area of ongoing work is optimising how the browser handles large location datasets. In countries with tens of thousands of administrative areas (such as the Philippines with over 42,000 barangays), the client-side code that processes location data can cause slower page interactions. This is a known optimisation target and does not affect server performance or data integrity.

***

{% hint style="info" %}
**Want the full details?** The complete performance test report — including methodology, per-operation breakdowns, infrastructure health metrics, and spike recovery analysis — is available on request. Contact the OpenCRVS team for a copy.
{% endhint %}
