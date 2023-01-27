
dbt-seed:
	dbt seed

dbt-run-day-0:
	dbt run --vars '{"process_dt": "2023-01-24"}'

dbt-run-day-1:
	dbt run --vars '{"process_dt": "2023-01-25"}'

dbt-run-day-2:
	dbt run --vars '{"process_dt": "2023-01-26"}'

dbt-snapshot-day-0:
	dbt snapshot --vars '{"process_dt": "2023-01-24"}'

dbt-snapshot-day-1:
	dbt snapshot --vars '{"process_dt": "2023-01-25"}'

dbt-snapshot-day-2:
	dbt snapshot --vars '{"process_dt": "2023-01-26"}'

all:
	make dbt-seed
	make dbt-run-day-0
	make dbt-snapshot-day-0
	make dbt-run-day-1
	make dbt-snapshot-day-1
	make dbt-run-day-2
	make dbt-snapshot-day-2
