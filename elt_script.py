import subprocess
import time
import psycopg2

DB_HOST = 'data-engineering-postgres'
DB_NAME = 'source_db'
DB_USER = 'postgres'
DB_PASSWORD = 'secret'


time.sleep(10)

try:
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()

    # Execute a query
    cursor.execute("SELECT * FROM users;")
    
    # Fetch data
    rows = cursor.fetchall()
    
    # Print the extracted data
    for row in rows:
        print(row)

    # Close connections
    cursor.close()
    conn.close()

except Exception as e:
    print("Error:", e)