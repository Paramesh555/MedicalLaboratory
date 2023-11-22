import streamlit as st
from pages import patient_input, view_tables

st.set_page_config(page_title="Medical Laboratory App", layout="wide")

st.sidebar.title("Navigation")
page = st.sidebar.selectbox("Choose a page", ["Patient Input", "View Tables",'role'])

if page == "Patient Input":
    patient_input.app()
elif page == "View Tables":
    view_tables.app()
elif page == "role"
