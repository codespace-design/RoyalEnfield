import pymysql

try:
    connection = pymysql.connect(host="localhost", user="root", password="root")
    cursor = connection.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS royal_enfield_db;")
    print("Database royal_enfield_db created successfully or already exists.")
    cursor.close()
    connection.close()
except Exception as e:
    print(f"Error creating database: {e}")
