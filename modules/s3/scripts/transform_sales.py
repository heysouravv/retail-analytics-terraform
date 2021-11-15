import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col, to_timestamp, date_format, when, lit

# Get job parameters
args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'SOURCE_DATABASE',
    'SOURCE_TABLE',
    'TARGET_BUCKET',
    'TARGET_DATABASE',
    'TARGET_TABLE'
])

# Initialize Glue context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read source data
source_data = glueContext.create_dynamic_frame.from_catalog(
    database=args['SOURCE_DATABASE'],
    table_name=args['SOURCE_TABLE'],
    transformation_ctx="source_data"
)

# Convert to DataFrame for easier transformation
sales_df = source_data.toDF()

# Data cleaning and transformation
transformed_df = sales_df \
    .withColumn("sale_date", to_timestamp(col("sale_date"), "yyyy-MM-dd HH:mm:ss")) \
    .withColumn("sale_year", date_format(col("sale_date"), "yyyy").cast("int")) \
    .withColumn("sale_month", date_format(col("sale_date"), "MM").cast("int")) \
    .withColumn("sale_day", date_format(col("sale_date"), "dd").cast("int")) \
    .withColumn("customer_id", col("customer_id").cast("int")) \
    .withColumn("product_id", col("product_id").cast("int")) \
    .withColumn("quantity", col("quantity").cast("int")) \
    .withColumn("unit_price", col("unit_price").cast("decimal(10,2)")) \
    .withColumn("total_price", col("unit_price") * col("quantity")) \
    .withColumn("discount_applied", when(col("discount").isNotNull(), lit(True)).otherwise(lit(False))) \
    .withColumn("discount_amount", 
                when(col("discount").isNotNull(), col("discount") * col("unit_price") * col("quantity"))
                .otherwise(lit(0.0))) \
    .withColumn("final_price", col("total_price") - col("discount_amount")) \
    .drop("discount") \
    .na.fill(0, ["quantity", "unit_price", "total_price", "discount_amount", "final_price"])

# Partition by year and month for better query performance
partitioned_df = transformed_df.repartition("sale_year", "sale_month")

# Convert back to DynamicFrame
transformed_dyf = DynamicFrame.fromDF(partitioned_df, glueContext, "transformed_data")

# Write to target location
target_path = f"s3://{args['TARGET_BUCKET']}/sales/"

# Write the data in Parquet format with partitioning
sink = glueContext.getSink(
    connection_type="s3",
    path=target_path,
    enableUpdateCatalog=True,
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=["sale_year", "sale_month"]
)

sink.setCatalogInfo(
    catalogDatabase=args['TARGET_DATABASE'],
    catalogTableName=args['TARGET_TABLE']
)

sink.setFormat("parquet", compression="snappy")
sink.writeFrame(transformed_dyf)

# Commit the job
job.commit()