# Performance

### 1. Introduction

OpenCRVS is built to run national-scale civil registration systems. This page explains what that means in practice: how many people can use it, how fast it responds, and how it handles pressure.\
\
All numbers on this page come from load tests run against a database of **1.2 million records** on a modest two-server (primary + secondary) setup. A larger deployment would perform even better.

***

### 2. At a glance

|                           |                                                     |
| ------------------------- | --------------------------------------------------- |
| **Simultaneous users**    | 1,000+ logged-in users at the same time             |
| **Registration speed**    | Under 350 ms to process a birth registration        |
| **Search speed**          | Under 60 ms to return search results                |
| **Error rate under load** | 0.00%                                               |
| **Spike recovery**        | Returns to normal within seconds of a traffic surge |

***

### 3. How many people can use it at once?

In testing, OpenCRVS handled over 1,000 users working at the same time: registrars filling in forms, staff searching for records, and supervisors monitoring workqueues. Every operation completed well within acceptable time limits.

For context, even in a country the size of the Philippines (\~117 million people), it's rare for more than a few hundred staff to be submitting registrations at the same moment. The system has plenty of room beyond typical peak demand.

The tests simulated realistic behaviour, including the time people spend reading screens and filling in forms, plus the background polling the OpenCRVS client does automatically. The number of virtual users in the test maps directly to the number of real people who could be logged in and working at once.

***

### 4. How fast is it?

Response times are measured server-side: the time the server takes to process a request, not counting network travel between the user's device and the server.

| What a user does            | How long the server takes |
| --------------------------- | ------------------------- |
| Log in                      | \~130 ms                  |
| Submit a birth registration | \~150 ms                  |
| Complete a registration     | \~170 ms                  |
| Search for a record         | \~25 ms                   |
| Open a record               | \~75 ms                   |
| Load the workqueue          | \~30 ms                   |

A typical web page takes 1 to 3 seconds to load. These server processing times are a small fraction of that, so most operations feel instant.

***

### 5. What happens during a traffic spike?

We tested a sudden jump to five times the normal load, the kind of thing you might see on a Monday morning, after a public holiday, or during a registration campaign.

The system handled it with no crashes, errors, or data loss. Once the spike passed, response times returned to normal within seconds, with no lingering effects: nothing got stuck, and later users saw no slowdown.

***

### 6. How big can the database get?

The test database held **1.2 million event records**, roughly six months of registration data for a country of 100 to 120 million people. At that scale, searches still returned in under 60 ms and registrations completed in under 350 ms.

For reference, a country registering 10,000 events a day builds up about 3.6 million records a year. Maintenance strategies like indexing and archival are available to keep performance steady as the dataset grows over the years.

***

### 7. What infrastructure does it need?

The test results above were achieved on a deliberately modest setup:

| Server    | Specification             |
| --------- | ------------------------- |
| Primary   | 8 CPU cores, 16 GB memory |
| Secondary | 4 CPU cores, 8 GB memory  |

This is a baseline configuration. National deployments can scale infrastructure up or horizontally to increase capacity further. Even on this small setup, the system never used more than half its available memory and experienced zero crashes or restarts.

***

### 8. What about the user's device?

The numbers above measure server-side speed only. The actual experience on someone's device also depends on their internet connection, browser, and hardware.

One area we're still working on is how the browser handles large location datasets. In countries with tens of thousands of administrative areas (the Philippines has over 42,000 barangays), the client-side code that processes location data can make page interactions slower. It's a known optimisation target and doesn't affect server performance or data integrity.

***

{% hint style="info" %}
**Want the full details?** The complete performance test report — including methodology, per-operation breakdowns, infrastructure health metrics, and spike recovery analysis — is available on request. Contact the OpenCRVS team for a copy.
{% endhint %}
