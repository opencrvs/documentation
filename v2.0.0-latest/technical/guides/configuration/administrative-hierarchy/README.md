# Administrative hierarchy

**TL;DR**

1. A country consists of a hierarchy of administrative areas.
2. The hierarchy structure is defined per country.
3. Not every level of the hierarchy needs to appear in every branch of the hierarchy tree (e.g. Province → Village).
4. Any level of the hierarchy may contain physical locations (e.g. hospitals, offices).
5. Each user must be assigned to a physical location.
6. Each user can belong to only one location.



### Introduction

\
In OpenCRVS, a country consists of a hierarchy of administrative areas. Administrative areas (such as provinces, districts, counties, cities, or villages) contain locations (such as CRVS offices, health facilities, or police stations). Locations serve two purposes: 1) as an identifiable place where events occur, and 2) as a place users are assigned to.<br>

The administrative hierarchy models a country's jurisdictional structure. A user's location in the hierarchy determines what they can see and do in the system.



**Example 1. Simple administrative hierarchy – Country -> Province -> District -> Village**

\
![](<../../../../.gitbook/assets/Screenshot 2026-05-06 at 12.05.28.png>)<br>

In this example of a 3-level hierarchy, each administrative area contains physical location(s), and each location has one or more users assigned to it. User jurisdiction is based on [scopes](../users/roles-and-scopes.md) given to their role.

Administrative areas form a hierarchy independently of locations. District A is the parent of Village A. Locations belong to administrative areas but do not have their own hierarchy — District Office A is not a parent of Village Office A. \
\
If all roles have actions limited to their `administrativeArea` then:

1. The Registrar General at HQ can perform actions across the entire country — Country, Province, District, and Village.
2. The Provincial Registrar at the Provincial Office can perform actions within Province A, District A, and Village A.
3. The Registrar at the District Office can perform actions within District A and Village A.
4. The Community Leader at the Village Office can perform actions within Village A.





