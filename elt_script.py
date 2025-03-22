import os
import time
import psycopg2
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# Determine Database Host (Docker or Local)
if os.getenv("DOCKER_ENV"):
    DB_HOST = "my_postgres"  
else:
    DB_HOST = "localhost"  

DB_NAME = "mydatabase"
DB_USER = "admin"
DB_PASSWORD = "admin123"
DB_PORT = 6004  

print(f"Using DB_HOST: {DB_HOST}")

# Initialize PySpark Session
spark = SparkSession.builder \
    .appName("Python_ETL") \
    .config("spark.jars.packages", "org.postgresql:postgresql:42.3.1") \
    .getOrCreate()

print("PySpark Session Initialized!")

while True:
    try:
        print("Connecting to database...")
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT, 
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cursor = conn.cursor()

        # Fetch Raw Data
        cursor.execute('SELECT * FROM "Member";')
        rows = cursor.fetchall()

        print("Fetched Data:")
        for row in rows:
            print(row)

        cursor.close()
        conn.close()
        print("Database connection closed.")

        # ETL Process Using PySpark
        print("Extracting data from PostgreSQL using PySpark...")

        df = spark.read \
            .format("jdbc") \
            .option("url", f"jdbc:postgresql://{DB_HOST}:{DB_PORT}/{DB_NAME}") \
            .option("dbtable", "Member") \
            .option("user", DB_USER) \
            .option("password", DB_PASSWORD) \
            .option("driver", "org.postgresql.Driver") \
            .load()

        print("Extracted Data:")
        df.show()

        # Transform: Convert mem_name to uppercase
        df_transformed = df.withColumn("MEMBER_NAME", col("mem_name"))

        print("Transformed Data:")
        df_transformed.show()

        # Load Transformed Data into PostgreSQL
        df_transformed.write \
            .format("jdbc") \
            .option("url", f"jdbc:postgresql://{DB_HOST}:{DB_PORT}/{DB_NAME}") \
            .option("dbtable", "Transformed_Member") \
            .option("user", DB_USER) \
            .option("password", DB_PASSWORD) \
            .option("driver", "org.postgresql.Driver") \
            .mode("overwrite") \
            .save()

        print("ETL Process Completed Successfully!")

    except Exception as e:
        print("❌ Error:", e)

    print("Waiting for 60 seconds before next run...")
    time.sleep(60)
