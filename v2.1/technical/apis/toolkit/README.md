# Toolkit

The toolkit is the primary dependency for building OpenCRVS country configurations. It exposes typed builders and helpers for defining events, forms, conditional logic, deduplication rules, and advanced search.

The toolkit version must match your OpenCRVS Core version exactly. If you are running OpenCRVS 2.0.0, install `@opencrvs/toolkit@2.0.0`.

```bash
npm install @opencrvs/toolkit@2.0.0
```

When upgrading OpenCRVS to a new version, upgrading the toolkit first is a good starting point. Type errors and breaking changes in your country configuration surface immediately at compile time, so you can address any required configuration updates before deploying.
