import pytest

from pyspark.sql import Row
from pyspark.testing.utils import assertDataFrameEqual

from pxspark.compute_authz_mapping import compute_authz_service_mapping

@pytest.fixture
def spark_fixture():
    from pyspark.sql import SparkSession
    spark = SparkSession.builder.appName("etl_test").getOrCreate()
    yield spark
    spark.stop()

def test_authz_service_mapping(spark_fixture):
    # load data from the otel-export-authz-source.json file
    data_source = spark_fixture.read.json("data/otel-export-authz-with-spiffe.json")
    df = compute_authz_service_mapping(data_source)

    # The output is expected to be a single row with the following structure:
    row = df.head()
    single_row_df = spark_fixture.createDataFrame([row])

    expected = [{
        "service_name": "backend",
        "client_http_target_method_map": [
            {
                "frontend-2": [
                    Row(
                        http_target="/transactions/transaction_2",
                        http_method="GET",
                    ),
                    Row(
                        http_target="/profiles/profile_2",
                        http_method="GET",
                    ),
                    Row(
                        http_target="/balances/balance_2",
                        http_method="GET",
                    ),
                ],
            },
            {
                "frontend": [
                    Row(
                        http_target="/profiles/profile_1",
                        http_method="GET",
                    ),
                    Row(
                        http_target="/transactions/transaction_1",
                        http_method="GET",
                    ),
                    Row(
                        http_target="/balances/balance_1",
                        http_method="GET",
                    ),
                ],
            },
        ],
    }]
    # The .select forces the columns to be in the same order as df
    expected_df = spark_fixture.createDataFrame(expected).select("service_name", "client_http_target_method_map")
    assertDataFrameEqual(single_row_df, expected_df)
    import pdb; pdb.set_trace()
