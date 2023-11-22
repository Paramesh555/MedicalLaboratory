import streamlit as st
import pandas as pd
import databaseConnection as dbc

db = dbc.fun()

def app():
    db.commit()
    st.title("Select Table and View Content")

    cursor = db.cursor()

    table_names = ['Patient', 'Orders', 'Report','Payment','DelayedTasks','Doctor']

    # Display a dropdown menu to select the table
    selected_table = st.selectbox("Select a table", table_names)

    if selected_table:
        st.title(f"Showing content of '{selected_table}' table")

        # Retrieve column names
        cursor.execute(f"DESCRIBE {selected_table}")
        column_names = [row[0] for row in cursor.fetchall()]

        # Fetch table data
        cursor.execute(f"SELECT * FROM {selected_table}")
        table_data = cursor.fetchall()

        # Convert table data to a pandas DataFrame
        data = pd.DataFrame(table_data, columns=column_names)

        st.table(data)

    # Close the cursor, not the database connection
    cursor.close()

def fetch_table_data(table_name):
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM {table_name}")
    table_data = cursor.fetchall()
    cursor.close()
    return table_data

