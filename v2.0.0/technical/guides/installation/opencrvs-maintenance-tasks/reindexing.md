# Reindexing

Reindexing is the process of rebuilding the search index that drives search, workqueues, and other core functionality in OpenCRVS. This page explains what the search index is, how reindexing works, and when you should run it as part of routine maintenance.

### What the search index is

OpenCRVS keeps the authoritative copy of every record in PostgreSQL. Search and workqueues, however, don't read from PostgreSQL directly — they read from a dedicated **search index**.

The search index is built by reading all record data from PostgreSQL and pre-processing it into a format that is optimised for fast, flexible searching. Reindexing is what (re)builds that index from the current contents of the database.

### What reindexing does

When a reindex runs, OpenCRVS reads every record from PostgreSQL and re-derives the searchable representation of each one. Because it works from PostgreSQL — the source of truth — a reindex always produces an index that reflects the true current state of your records. This makes it both a build step and a recovery mechanism: if the index ever drifts out of sync or needs to reflect new configuration, reindexing brings it back into alignment.

### Notifying country config

While a reindex is in progress, OpenCRVS notifies the country config package. This gives country config a hook to reprocess records in step with the core reindex — for example, to rebuild or refresh an **analytics database** from the same record data.

Because the notification fires whenever reindexing runs (both automatically on deployment and when triggered manually), any reprocessing you wire into this mechanism stays in sync with the core search index without needing a separate trigger.

### When to reindex

#### After configuration changes

You should reindex **every time your OpenCRVS country configuration changes**. Configuration can affect how records are interpreted and indexed, so the search index must be rebuilt for those changes to take full effect across search and workqueues.

This is handled for you automatically: **reindexing runs as part of deployment.** In the normal course of shipping configuration changes, you don't need to trigger it manually.

#### As a manual maintenance action

There are times when you may want to run a reindex outside of a deployment — for example, to recover from a search index that has become inconsistent, or to verify that the index matches the database. For these cases you can trigger a reindex manually (see below).

### Running a reindex manually

You can trigger a reindex on demand using the **reindex pipeline** in your forked infrastructure repository:

[https://github.com/opencrvs/infrastructure/actions/workflows/reindex.yml](https://github.com/opencrvs/infrastructure/actions/workflows/reindex.yml)

Run the workflow from there against the environment you want to reindex.

### How long it takes

The time a reindex takes is fully proportional to how many records are in the database — the more records, the longer it runs. In most cases it should complete in **under one hour**.
