# Certificates

Certificates in OpenCRVS are printable PDF documents generated from registered event records. They are built from SVG templates that use Handlebars syntax — a familiar `{{expression}}` format — to pull in record data at print time. Core handles the rendering pipeline; everything else (which templates exist, what data they show, how they look) is configured in countryconfig.

The three topics below cover the building blocks you need to design and configure certificate templates:

* [**Built-in helpers and template variables**](built-in-helpers-and-template-variables.md) — the data and helper functions that core makes available in every template out of the box.
* [**Custom Handlebars.js helpers**](custom-handlebars.js-helpers.md) — how to write country-specific helper functions for formatting, translation, and logic that the built-in helpers don't cover.
* [**Multi-page certificate templates**](multi-page-certificate-templates.md) — how to structure an SVG file that renders as multiple PDF pages.

