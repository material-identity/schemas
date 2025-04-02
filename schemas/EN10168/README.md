# EN10168

The `./schema.json` is an implementation of the European Union steel standards of the same name. This directory contains translations and templates used for validation and PDF rendering of EN10168 certificates.

## Changelog (v0.5.0)

- Added attribute `Method` to KeyValueObject ([#102](https://github.com/material-identity/schemas/issues/102))
- Added type `image` to KeyValueObject ([#108](https://github.com/material-identity/schemas/issues/108))
- Added types `email` and `phone` to KeyValueObject ([#107](https://github.com/material-identity/schemas/issues/107))
- Added type `url` to KeyValueObject ([#101](https://github.com/material-identity/schemas/issues/101))
- Added comparison operators `<`, `>`, `=`, `>=` and `<=` to chemical analysis ([#104](https://github.com/material-identity/schemas/issues/104))
- Added property `A06.4 Subpurchaser` ([#99](https://github.com/material-identity/schemas/issues/99))
- Added support for visual stamp for the inspection representative ([#96](https://github.com/material-identity/schemas/issues/96))
- Added `Unit` to chemical analysis and display it in table view ([#98](https://github.com/material-identity/schemas/issues/98))
- Added `Formula` to chemical element and display it in list ([#98](https://github.com/material-identity/schemas/issues/98))
- Changed `CompanyName` to `Name` to standardize naming over all schemas.
- Removed restriction to `Y` and `E` on C70 field values ([#111](https://github.com/material-identity/schemas/issues/111))
- Removed obsolete `Company/AdditionalInformation`.
- Removed obsolete `DocumentMetaData`.

## Changelog (v0.4.1)

- Added `product` object to the schema to describe the product details.
