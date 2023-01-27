# Adding Operational Metadata to dbt Snapshots
dbt provides out-of-the-box change data capture functionality for tracking changes to data in your data lake or
data warehouse through the (dbt snapshot)[https://docs.getdbt.com/docs/build/snapshots] features.  This includes
support for several strategies (`timestamp` and `check_cols`) for detecting change.  In addition, the documentation
provides guidance on implementing (custom change detection strategies)[https://docs.getdbt.com/reference/resource-configs/strategy#advanced-define-and-use-custom-snapshot-strategy].

Those two default strategies often meet the change detection requirements for a project, but in some implementations
there is a requirement for a more detailed set of operational metadata, e.g.  which process was responsible for which
change to data in the data lake or data warehouse.  This could be driven by either operational requirements or compliance
requirements, or both.

To enable greater operational visibility and auditiable governance, injecting additional operational metadata
in addition to the standard dbt snapshot fields.

## Objectives
The need for greater fidelity of operational metadata can be driven by both operational and governance requirements.
The following considerations are addressed:
* use the out-of-the-box dbt snapshot logic and strategies for Change Data Capture (CDC)
* add operational metadata fields to snapshot tables with processing details for operational support and audit
* when new records are inserted, add operational processing metadata information to each record
* when an existing record is closed or end-dated, update operational metadata fields with operational processing metadata
* accomodate a legacy requirement for the high end timestamp to have a non-null value

### Note on High End Dates/Timestamps
Many legacy systems use a high value, such as '9999-12-31' or '999-12-31 23:59:59.999999' for the end date/time values
for open records.  In many cases, those legacy systems haven't had to considerin timezone implications, e.g. a default
timezone for the database or timestamp precision, e.g. number of milliseconds to include in the high datetime value.
Using `NULL` values for the end date/time value for open records is `HIGHLY` recommended.

For example, the BigQuery
```
datetime('9999-12-31 23:59:59.999999', 'Australia/Melbourne')
```
will generate an error, while
```
timestamp('9999-12-31 23:59:59.999999', 'Australia/Melbourne')
```
will silently convert the localised timestamp to UTC `9999-12-31 23:59:59.999999+00`

However, in some instances, the change from high date/time values to NULL values for the high end date/time of open
records has to be perserved.  This example provides one possible solution for including non-null high end date/time
values.

## Out-of-the-Box dbt Snaphots

## Overriding Snapshot behaviour