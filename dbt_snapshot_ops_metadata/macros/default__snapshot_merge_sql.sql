{% macro default__snapshot_merge_sql(target, source, insert_cols) -%}
{#- customised snapshot merge statement to update additional operational metadata #}
    {%- set insert_cols_csv = insert_cols | join(', ') -%}

    merge into {{ target }} as DBT_INTERNAL_DEST
    using {{ source }} as DBT_INTERNAL_SOURCE
    on DBT_INTERNAL_SOURCE.dbt_scd_id = DBT_INTERNAL_DEST.dbt_scd_id

    when matched
     and DBT_INTERNAL_DEST.dbt_valid_to is null
     and DBT_INTERNAL_SOURCE.dbt_change_type in ('update', 'delete')
        then update
        set 
            dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to,
            {#- additional operational metadata fields to be updated #}
            EFFECTIVE_END_TIMESTAMP = DBT_INTERNAL_SOURCE.EFFECTIVE_END_TIMESTAMP,
            UPDATE_PROCESS_ID = DBT_INTERNAL_SOURCE.UPDATE_PROCESS_ID,
            UPDATE_TIMESTAMP = DBT_INTERNAL_SOURCE.UPDATE_TIMESTAMP

    when not matched
     and DBT_INTERNAL_SOURCE.dbt_change_type = 'insert'
        then insert ({{ insert_cols_csv }})
        values ({{ insert_cols_csv }})

{% endmacro %}