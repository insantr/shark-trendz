
{{ config(
    materialized='table',
    partition_by={
      "field": "date_incident",
      "data_type": "date",
      "granularity": "year"
    }
) }}


WITH source_data AS (
  SELECT
    Date as date_incident,
    Type as type_incident,
    Country as country,
    State as state,
    Location as location,
    Activity as activity,
    Age as age,
    CASE
        WHEN `Unnamed__11` = 'Y' THEN TRUE
        ELSE FALSE
    END AS if_fatal,
    CASE
        WHEN Sex = 'F' THEN 'Female'
        WHEN Sex = 'M' THEN 'Men'
        ELSE 'Unknown'
    END AS clean_sex
  from {{ source('staging','shark_trendz_main') }}
)

SELECT
    {{ dbt.safe_cast("date_incident", api.Column.translate_type("date")) }} as date_incident,
    type_incident,
    country,
    state,
    location,
    activity,
    {{ dbt.concat(["country", "', '", "state", "', '", "location"]) }} as address,
    if_fatal,
    {{ dbt.safe_cast("age", api.Column.translate_type("integer")) }} as age,
    clean_sex as sex
FROM source_data
