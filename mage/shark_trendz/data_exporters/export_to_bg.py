from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a BigQuery warehouse.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#bigquery
    """
    from google.cloud import bigquery
    import os

    # Инициализируем клиент BigQuery
    client = bigquery.Client()

    project_id = os.getenv('PROJECT_ID')
    dataset_id = 'tmp_dataset1'
    table_id = 'tmp_table1'
    full_table_id = f"{project_id}.{dataset_id}.{table_id}"

    # Проверяем существование датасета, если нет - создаем
    dataset_ref = client.dataset(dataset_id)
    try:
        client.get_dataset(dataset_ref)
    except Exception:
        # Создаем датасет
        dataset = bigquery.Dataset(dataset_ref)
        dataset = client.create_dataset(dataset)
        print(f"Датасет {dataset_id} создан.")

    # Определяем настройки задания
    job_config = bigquery.LoadJobConfig()
    job_config.schema = [
        bigquery.SchemaField("Date", "INTEGER"),
        bigquery.SchemaField("Year", "INTEGER"),
    ]
    job_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE

    # Загружаем DataFrame в BigQuery
    job = client.load_table_from_dataframe(df, full_table_id, job_config=job_config)
    job.result()  # Ожидаем завершения загрузки
