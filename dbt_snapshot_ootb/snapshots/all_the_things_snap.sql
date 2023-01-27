{%- snapshot all_the_things_snap -%}
{{ config(
  unique_key='thing_id'
  , strategy = "check"
  , check_cols = ["status", "description"]
) }}

select *
from {{ ref('all_the_things_xform') }}

{%- endsnapshot -%}