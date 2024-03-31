   CREATE OR REPLACE EXTERNAL TABLE `{{ env_var("GCP_PROJECT_ID") }}.{{ env_var("BQ_DATASET_NAME") }}.shark_trendz_main`
    OPTIONS (
    format = 'parquet',
    uris = ['gs://{{ env_var("GCS_BUCKET") }}/shark_attack.parquet']
    )