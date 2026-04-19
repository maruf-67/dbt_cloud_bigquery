# Dimensions

## Current dimension set

### `dim_identity_map`
- Status: implemented.
- Role: identity stitching across hashed lead identity and behavior identifiers.

## Planned/scaffolded dimensions
- `dim_campaigns`
- `dim_channels`
- `dim_dates`

These are currently placeholders and should not be treated as production dimensions until SQL logic and tests are implemented.

## Dimension standards
- clear natural key and surrogate key policy.
- SCD behavior documented where required.
- descriptive metadata for BI discoverability.
- tests for uniqueness and nullability on primary business keys.
