from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path
from datetime import datetime
import pytz
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """



    bucket_name = os.getenv('GCS_BUCKET')
    # now = datetime.utcnow()
    # pt = pytz.timezone("America/Los_Angeles")
    # now_pst = pytz.utc.localize(now).astimezone(pt)
    # object_key = f'test_file_{now_pst.strftime("%Y-%m-%d")}.csv'


    # from google.cloud import storage
    # storage_client = storage.Client()
    # bucket = storage_client.bucket(bucket_name)
    # blob = bucket.blob(object_key)

    # blob.upload_from_string(df.to_csv())

    

    # df = df.loc[df['Date'].dt.year < 2020]

    import pyarrow as pa
    import pyarrow.parquet as pq
    table = pa.Table.from_pandas(df)
    gcs = pa.fs.GcsFileSystem()

    root_path = f'{bucket_name}/shark_attack_lake'

    pq.write_to_dataset(
        table,
        root_path=root_path,
        filesystem=gcs,
        basename_template='shark_attack_dataset-{i}.parquet'
    )
