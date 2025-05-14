# Variables & functions

## Available top-level variables

- `$state`: Event record in it current state
- `$declaration`: Raw declaration data

## Available top-level functions

### `$lookup`
Used for direct property lookup within objects.
- `$lookup $state "modifiedAt"`
- `$lookup $state "updatedAtLocation"`
- `$lookup $state "createdAtLocation"`
- `$lookup $state "assignedTo"`
- `$lookup $declaration "child.firstname"`
- `$lookup $declaration "child.surname"`
- `$lookup $declaration "child.gender"`

### `$intl`
Looks up i18n translation strings.
- `$intl 'constants' ($lookup $declaration "child.gender")`
- `$intl 'v2.constants.informant' ($lookup 'informant.relation')`

### `$or`
Returns the first non-undefined value among two expressions.
- `$or ($lookup 'child.address.other.district') ($lookup 'child.address.other.district2')`

### `$formatDate`
Formats a date using a given format string.
- `$formatDate ($lookup $state "modifiedAt") "dd MMMM yyyy"`
- `$formatDate ($lookup $state "createdAt") "dd MMMM yyyy"`

Besides the ones introduced above, all built-in [Handlebars helpers](https://handlebarsjs.com/guide/builtin-helpers.html) are available.
You can also add custom helpers by exposing functions from this [file](https://github.com/opencrvs/opencrvs-countryconfig/blob/develop/src/form/common/certificate/handlebars/helpers.ts#L0-L1).


