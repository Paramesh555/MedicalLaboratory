import databaseConnection as dbc
import streamlit as st
import pandas as pd

def app():
    db = dbc.fun()
# Create a cursor to interact with the database
    cursor = db.cursor()
    st.title("Patient report")

    patient_id = st.text_input("Enter your id")
    if st.button("check"):
        cursor.execute("SELECT check_payment(%s)", (patient_id,))
        result = cursor.fetchone()[0]
        # print(type(result))
        if result == 0:
            cursor.execute("select check_amount(%s)",(patient_id,))
            res = cursor.fetchone()[0]
            # print(type(res))
            st.write("please pay,"+str(res)+"rupees")
        else:
            cursor.execute(f"select * from report where patientid ={patient_id} ")
            table_data = cursor.fetchall() 
            if table_data:
                df = pd.DataFrame(table_data, columns=[i[0] for i in cursor.description])
                st.write("Table Data:")
                st.write(df)  # Display the DataFrame using st.write()

        
