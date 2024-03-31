import pandas as pd
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    data['Date'] = data['Date'].str.replace('Reported\s+', '', regex=True)
    data['Date'] = pd.to_datetime(data['Date'], dayfirst=True, errors='coerce')
    data.dropna(subset=['Date'], inplace=True)

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
