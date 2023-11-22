import mysql.connector

def fun():
        # Establish a database connection to retrieve data from the Test table
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="your password",
        database="laboratory",
        auth_plugin="mysql_native_password"
    )
    return db