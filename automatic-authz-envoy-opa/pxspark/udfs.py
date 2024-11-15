from pyspark.sql.functions import split, udf, when
from pyspark.sql.types import StringType

@udf(returnType=StringType())
def extract_url_prefix(url):
    if url is None:
        return url
    # Pixie's OTel plugin uses "<id>" as a placeholder for hex IDs in the URL
    # Extract the prefix prior to the "<id>" placeholder
    if "<id>" in url:
        return url.split("<id>")[0].rstrip("/")
    return url
