# Adding Operational Metadata to dbt Snapshots
The out-of-the-box [dbt snapshots](https://docs.getdbt.com/docs/build/snapshots) provide change data capture (CDC) capability for tracking the changes to data in your
data lake or data warehouse.  The dbt snapshot metadata columns enable a view of change to data - which records 
have been updated when.   However, the dbt snapshot metadata doesn't provide a view of processing audit - which process
or job was responsible for the changes.  Additional operational metadata is required for process level auditability.

In those cases where greater operational visibility is required, the dbt snapshot behaviour (snapshot strategies)
may provide the right logic for detecting and managing data change.  No change to the change detection strategy
or snapshot sequence of pipeline processing is desired, but additional operational metadata fields should be set and
carried through the processing pipeline along with the data.

## Objectives
The need for greater fidelity of operational metadata can be driven by both operational and governance requirements.
Some example considerations could include:
* use the out-of-the-box dbt snapshot logic and strategies for Change Data Capture (CDC)
* add operational metadata fields to snapshot tables with processing details for operational support and audit
  - when new records are inserted, add operational processing metadata information to each record
  - when an existing record is closed or end-dated, update operational metadata fields with operational processing metadata

```mermaid
title before and after snapshot tables
```

### Bonus - High End Date/Timestamp
In addition to the operational support and audit requirements, there can also be a legacy migration complication
related to how open records (the most current version of the record) are represented snapshots.  In dbt snapshots,
open records represented using `NULL` values for `valid_to` fields, as opposed to a well-known high value for date
or timestamp fields.  In legacy data lakes or data warehouses, the open records often are identified by using a
well-knowb high value for the effective end date/timestamp, such as `9999-12-31` or `9999-12-31 23:59:59`.  Adding
additional snapshot metadata columns enables a legacy view of record changes without having to alter the
dbt snapshot strategy or processing logic.

```mermaid
title example high dttm values
```

Note that transitioning to the use of `NULL` values for the `valid_to` end date/timestamp value for open records
is `HIGHLY` recommended, especially if porting to a new database platform or cloud based service.  On-premise
legacy database platforms often use `TIMESTAMP` values without inclusion of timezones or timezone offests and
rely on a system wide default timezone setting.
Different databases may also have different millisecond precision for `TIMESTAMP` columns.
When migrating to a new database platform, both precision and timezone treatment can cause unexpected issues.

For example, in BigQuery
```
datetime('9999-12-31 23:59:59.999999', 'Australia/Melbourne')
```
will generate an invalid value error, while
```
timestamp('9999-12-31 23:59:59.999999', 'Australia/Melbourne')
```
will silently convert the localised timestamp to UTC `9999-12-31 23:59:59.999999+00`

Using `NULL` values for open records/`valid_to` fields avoids this risk of subtle breakage.

## Out-of-the-Box dbt Snaphots

## Overriding Snapshot behaviour