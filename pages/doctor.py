import databaseConnection as dbc
import streamlit as st

def app():
    st.title("Update Doctor Specialization")

# Collect user input - Doctor ID and New Specialization
    doctor_id = st.text_input("Enter Doctor ID:")
    new_specialization = st.text_input("Enter New Specialization:")

# Perform update on button click
    if st.button("Update Specialization"):
        if doctor_id and new_specialization:
            update_doctor_specialization(doctor_id, new_specialization)
        else:
            st.warning("Please fill in both Doctor ID and New Specialization fields.")


def update_doctor_specialization(doctor_id, new_specialization):
    db = dbc.fun()
    cursor = db.cursor()
    # Execute the UPDATE query
    cursor.execute("UPDATE doctor SET specialization = %s WHERE doctorId = %s", (new_specialization, doctor_id))
    affected_rows = cursor.rowcount
    db.commit()

    if affected_rows >0:
        st.success("Doctor specialization updated successfully.")
    else:
        st.warning(f"No doctor found with ID {doctor_id}. Specialization not updated.")
    