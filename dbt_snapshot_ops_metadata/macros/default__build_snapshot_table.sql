{% macro default__build_snapshot_table(strategy, sql) %}
{#- customised snapshot table to inject additional operational metadata #}

    select *, 
        {#- additional operational metadata fields #}
        cast("{{ invocation_id }}" as STRING) as INSERT_PROCESS_ID,
        cast(NULL as STRING) as UPDATE_PROCESS_ID,
        {{ strategy.updated_at }} as EFFECTIVE_START_TIMESTAMP,
        cast("{{ var('default_high_dttm') }}" as TIMESTAMP) as EFFECTIVE_END_TIMESTAMP,
        {{ strategy.updated_at }} as INSERT_TIMESTAMP,
        cast(NULL as TIMESTAMP) as UPDATE_TIMESTAMP,

        {#- dbt standard snapshot fields #}
        {{ strategy.scd_id }} as dbt_scd_id,
        {{ strategy.updated_at }} as dbt_updated_at,
        {{ strategy.updated_at }} as dbt_valid_from,
        nullif({{ strategy.updated_at }}, {{ strategy.updated_at }}) as dbt_valid_to
    from (
        {{ sql }}
    ) sbq

{% endmacro %}
