import sys
import os
import traceback
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame
from pyspark.conf import SparkConf
from pyspark.sql import DataFrame, Row
from pyspark.sql.window import Window
from pyspark.sql.types import *
from pyspark.sql.functions import (
  col,
  desc,
  row_number,
  to_timestamp,
  from_json,
  to_date
)

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
S3_OUPUT_env = getResolvedOptions(sys.argv, ['S3_OUTPUT'])
S3_CHECKPOINT_env = getResolvedOptions(sys.argv, ['S3_CHECKPOINT'])
KAFKA_BOOTSTRAP_SERVER_env = getResolvedOptions(sys.argv, ['BOOTSTRAP_SERVER'])
KAFKA_TOPIC_env = getResolvedOptions(sys.argv, ['TOPIC'])



sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)



schema = StructType([StructField("exchangeId", StringType(), True),
                          StructField("name", StringType(), True),
                          StructField("rank", StringType(), True),
                          StructField("percentTotalVolume", StringType(), True),
                          StructField("volumeUsd", StringType(), True),
                          StructField("tradingPairs", StringType(), True),
                          StructField("exchangeUrl", StringType(), True),
                          StructField("updated", StringType(), True),
                          StructField("update_dt", StringType(), True)])

alias = "clean_coin_data"


    
def get_raw_df(sparks, schema, alias):
    """
            :param spark: spark session for the streaming app
            :param alias_value: The alias value for the clean data frame
            :return: spark dataframe from the kafka consumer
    """
    """
         Creating a consumer for the kafka prodcuer running inside a docker container 
         exposed at localhost:9093.
    """
    return sparks \
        .readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "{}".format(KAFKA_BOOTSTRAP_SERVER_env)) \
        .option("offsets.retention.minutes", "1440") \
        .option("subscribe", "{}".format(KAFKA_TOPIC_env)) \
        .option("startingOffsets", "earliest") \
        .load() \
        .selectExpr("CAST(value AS STRING)") \
        .select(from_json(col("value"), schema)) \
        .select("from_json(value).*") \
        .withColumn('timestamp', to_timestamp('update_dt')) \
        .withColumn('date', to_date('timestamp')) \
        .alias(alias)



def stream_data(spark_stream):
    """
            :param spark_stream: spark dataframe from the kafka consumer for the streaming app
            :return: spark streaming query object
    """
    query = spark_stream \
        .writeStream \
        .format("parquet") \
        .outputMode("append") \
        .partitionBy("date") \
        .option("path", "s3://{}/bitcoin/".format(S3_OUPUT_env)) \
        .option("checkpointLocation", "s3://{}/bitcoin-checkpoint/"/format(S3_CHECKPOINT_env)) \
        .start()
    query.awaitTermination(180)
    query.stop()
    return query



if __name__ == '__main__':
    stream_df = get_raw_df(spark, schema, alias)
    stream_data(stream_df)



job.commit()
    