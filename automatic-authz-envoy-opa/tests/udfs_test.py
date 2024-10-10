from importlib import reload

from mock import patch
import pxspark.udfs as UDFs

def dummy_udf(f):
    return f


def mock_udf(f=None, returnType=None):
    return f if f else dummy_udf

class TestUDFs:
    udf_patch = patch('pyspark.sql.functions.udf', mock_udf)

    @classmethod
    def setup_class(cls):
        cls.udf_patch.start()
        reload(UDFs)

    @classmethod
    def teardown_class(cls):
        cls.udf_patch.stop()
        reload(UDFs)

    def test_extract_url_prefix_with_identity_url(self):
        url = "/px/vizier/services/metadata/CronScriptStoreService/RecordExecutionResult"
        assert UDFs.extract_url_prefix(url) == url

    def test_extract_url_prefix_with_id_substitute(self):
        url = "/carts/<id>/items"
        assert UDFs.extract_url_prefix(url) == "/carts"

        assert UDFs.extract_url_prefix("/addresses/<id>") == "/addresses"
