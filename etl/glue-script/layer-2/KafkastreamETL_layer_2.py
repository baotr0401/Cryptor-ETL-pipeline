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
)

from pyspark.sql.types import *


args = getResolvedOptions(sys.argv, ['JOB_NAME'])
S3_LAYER_1_env = getResolvedOptions(sys.argv, ['S3_OUTPUT'])
S3_OUTPUT_env = getResolvedOptions(sys.argv, ['S3_OUTPUT'])
S3_CHECKPOINT_env = getResolvedOptions(sys.argv, ['S3_CHECKPOINT'])

sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

def get_s3_df():
    return spark \
            .read \
            .load("s3://{}/bitcoin/".format(S3_LAYER_1_env), 
                format="parquet", 
                inferSchema="true", 
                header="true")
                
                
            
def get_latest_exchange(s3_df):
    """
            :param s3_df: spark dataframe from s3
            :return: most recent volume statistics on 73 exchange ids
    """
    """
         Convert volume in $ to decimal
         Convert percent volume in % to decimal
         Convert trading pairs to integer
         Convert rank to integer
         Groupby exchaneId 
         Reflect latest timestamp
         Reflect sum of volumeUsd
         Reflect mean of percentTotalVolume
         Reflect most recent exchanges' ranking and trading pairs
         Add exchange id
    """
    return s3_df \
            .withColumn("volumeUsd",col("volumeUsd").cast(DecimalType(18, 8))) \
            .withColumn("percentTotalVolume",col("percentTotalVolume").cast(DecimalType(38, 8))) \
            .withColumn("tradingPairs",col("tradingPairs").cast(IntegerType())) \
            .withColumn("rank",col("tradingPairs").cast(IntegerType())) \
            .drop("update_dt") \
            .orderBy(desc('timestamp')) \
            .groupBy("exchangeId") \
            .agg(max("timestamp").alias("latest") \
                ,sum("volumeUsd").alias("total_volume") \
                ,max("date").alias("date") \
                ,mean("percentTotalVolume").alias("total_volume_percentage") \
                ,first("rank").alias('rank') \
                ,first("tradingPairs").alias('trading_pairs'))

def write_data(spark_df):
    spark_df \
        .write \
        .format("parquet") \
        .mode("overwrite") \
        .partitionBy("date") \
        .option("path", "s3://{}/bitcoin/".format(S3_OUTPUT_env)) \
        .option("checkpointLocation", "s3:/{}/bitcoin-checkpoint/".format(S3_CHECKPOINT_env)) \
        .start()

if __name__ == '__main__':
    source = get_s3_df()
    spark_processed_df = get_latest_exchange(source)
    write_data(spark_processed_df)
    
job.commit()
                        