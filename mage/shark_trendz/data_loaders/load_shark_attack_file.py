import io
import os
import pandas as pd
import requests
from tempfile import NamedTemporaryFile
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


def download_file_and_load_to_pandas(url):
    # Creating a temporary file
    with NamedTemporaryFile(delete=False, suffix='.xls') as tmp_file:
        # Downloading the file
        response = requests.get(url)
        # Checking for a successful response
        if response.status_code == 200:
            # Writing the content to the temporary file
            tmp_file.write(response.content)
            tmp_file_path = tmp_file.name
            # Loading data from the file into a pandas DataFrame
            df = pd.read_excel(tmp_file_path)
            # Printing the first few rows of the DataFrame for verification
            return df
        else:
            raise Exception(f"Error downloading the file: status {response.status_code}")

    # Deleting the temporary file
    os.remove(tmp_file_path)


@data_loader
def load_data_from_api(*args, **kwargs):
    url = 'https://www.sharkattackfile.net/spreadsheets/GSAF5.xls'
    data = download_file_and_load_to_pandas(url)
    
    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
