import streamlit as st
import databaseConnection as dbc
import datetime




db = dbc.fun()

cursor = db.cursor()

def app():

    db = dbc.fun()

    cursor = db.cursor()

    st.title("Patient Information Input")


    



    first_name = st.text_input("First Name")
    last_name = st.text_input("Last Name")
    date_of_birth = st.date_input("Date of Birth")
    phone_number = st.text_input("Phone Number")
    #create a selector for doctor names
    doctor_data = fetch_doctor_data()
    doctor_name_to_id = {doctor[1]+doctor[2] :doctor[0] for doctor in doctor_data}
    selected_doctor = st.selectbox("select doctor name",list(doctor_name_to_id.keys()))
    selected_doctor_id = doctor_name_to_id[selected_doctor]

    # Create a multiselect input for test names
    test_data = fetch_test_data()
    test_name_to_id = {test[1]: test[0] for test in test_data}
    selected_tests = st.multiselect("Select Test Names", list(test_name_to_id.keys()))
    # Map the selected test names to their corresponding testIds
    selected_test_ids = [test_name_to_id[test_name] for test_name in selected_tests]
    # Display the selected testIds
    st.write("Selected Test IDs:", selected_test_ids)
    
    


# Create a button to submit the form
    if st.button("Submit"):
    # Insert the user input data into the MySQL table
        insert_query = "INSERT INTO Patient (FName, DOB, LName, phoneNO) VALUES (%s, %s, %s, %s)"
        data = (first_name, date_of_birth, last_name, phone_number)

        cursor.execute(insert_query, data)
        db.commit()

        cursor.execute("SET @patientIdvar = LAST_INSERT_ID()")
        cursor.execute("select @patientIdvar")
        patient_id = cursor.fetchone()
        patient_id = patient_id[0]

        Todaydate = datetime.date.today().strftime('%Y-%m-%d')
        orderIdvar = call_create_order_and_set_orderIdvar(patient_id,Todaydate,selected_doctor_id)
        db.commit()

        call_create_order_and_test(orderIdvar,selected_test_ids)
        db.commit()

        call_get_cost_update(orderIdvar)
        


    


# Close the MySQL connection
    db.commit()
    cursor.close()
    db.close()


def call_create_order_and_set_orderIdvar(patient_id, date,doctor_id):
    cursor.callproc('create_order', (patient_id,date,doctor_id))

    db.commit()
    # Set the orderIdvar variable using LAST_INSERT_ID()
    cursor.execute("SET @orderIdvar = LAST_INSERT_ID()")

    # Fetch the orderIdvar value
    cursor.execute("select @orderIdvar")
    order_id = cursor.fetchone()
    order_id = order_id[0]

    return order_id

def call_create_order_and_test(order_id,test_id):
    for i in test_id:
        cursor.callproc('create_order_test',(order_id,i))
        db.commit()


def call_get_cost_update(order_id):

    cursor.callproc('get_cost_update',(order_id,))
    db.commit()


def fetch_test_data():
    cursor.execute("select * from test")
    return cursor.fetchall()  

def fetch_doctor_data():
    cursor.execute("select * from doctor")
    return cursor.fetchall()

