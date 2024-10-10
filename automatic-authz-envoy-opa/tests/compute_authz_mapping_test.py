import pytest

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

    # The test file contains a ton of data, but we only care to match the rough shape of the output
    row = df.count().head()
    single_row_df = spark_fixture.createDataFrame([row])

    expected = [{
        "client_name": "frontend",
        "service_name": "backend",
        "http_target": "/profiles/profile_1",
        "http_method": "GET",
        "count": 1607,
    }]
    # The .select forces the columns to be in the same order as df
    expected_df = spark_fixture.createDataFrame(expected).select("service_name", "client_name", "http_target", "http_method", "count")
    assertDataFrameEqual(single_row_df, expected_df)
