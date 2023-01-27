
select *
from {{ ref('all_the_source_data') }}
where txn_date = '{{ var("process_dt") }}'