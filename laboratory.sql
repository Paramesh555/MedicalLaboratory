show databases;
DROP DATABASE IF EXISTS laboratory;
create database laboratory;
use laboratory;

CREATE TABLE Doctor
(
 doctorId int auto_increment NOT NULL,
 FName VARCHAR(15) NOT NULL,
 LName VARCHAR(15) NOT NULL,
 specialization VARCHAR(30) NOT NULL,
 phoneNo VARCHAR(15) NOT NULL,
 PRIMARY KEY (doctorId)
);

CREATE TABLE Patient
(
 patientId int auto_increment NOT NULL,
 FName VARCHAR(15) NOT NULL,
 LName VARCHAR(15) NOT NULL,
 DOB DATE NOT NULL,
 phoneNO VARCHAR(15) NOT NULL,
 PRIMARY KEY (patientId)
);




CREATE TABLE Orders
(
 orderId int auto_increment NOT NULL,
 dateOrdered DATE NOT NULL,
 status ENUM("DONE","PENDING") NOT NULL,
 totalCost INT DEFAULT 0,
 patientId int NOT NULL,
 doctorId int NOT NULL,
 PRIMARY KEY (orderId),
 FOREIGN KEY (patientId) REFERENCES Patient(patientId),
 FOREIGN KEY (doctorId) REFERENCES Doctor(doctorId)
);

CREATE TABLE Payment
(
 paymentId int auto_increment NOT NULL,
 paymentAmount INT NOT NULL,
 orderId int NOT NULL,
 PRIMARY KEY (paymentId),
 FOREIGN KEY (orderId) REFERENCES Orders(orderId)
);

CREATE TABLE Test
(
 testId int auto_increment NOT NULL,
 testName VARCHAR(30) NOT NULL,
 price INT NOT NULL,
 normalRange varchar(25) NOT NULL,
 sampleType VARCHAR(25) NOT NULL,
  
 PRIMARY KEY (testId)
);

CREATE TABLE Report
(
 reportId int auto_increment NOT NULL,
 result VARCHAR(15) NOT NULL,
 testId int NOT NULL,
 doctorId int NULL,
 patientId int NOT NULL,
 PRIMARY KEY (reportId),
 FOREIGN KEY (testId) REFERENCES Test(testId),
 FOREIGN KEY (doctorId) REFERENCES Doctor(doctorId),
 FOREIGN KEY (patientId) REFERENCES Patient(patientId)
);

CREATE TABLE test_order
(
	testId int NOT NULL,
  orderId int NULL,
  FOREIGN KEY (testId) references Test(testId),
  FOREIGN KEY (orderId) references ORDERS(orderId)
);


INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Blood Glucose', 100, '80 mg/dL', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Cholesterol', 150, '180 mg/dL', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Triglycerides', 120, '150 mg/dL', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Blood Pressure', 200, '120/80 mmHg', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Body Mass Index (BMI)', 180, '18.5-24.9', 'Measurement');

INSERT INTO Test ( testName, price, normalRange, sampleType)
VALUES ('Complete Blood Count', 250, 'Within normal limits', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Basic Metabolic Panel', 300, 'Within normal limits', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Thyroid Stimulating Hormone', 150, '0.34-4.82 mIU/L', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Vitamin D', 200, '30-100 ng/mL', 'Blood');

INSERT INTO Test (testName, price, normalRange, sampleType)
VALUES ('Urinalysis', 120, 'Within normal limits', 'Urine');

INSERT INTO Doctor (FName, LName, specialization, phoneNo)
VALUES ('John', 'Smith', 'Cardiology', '123-456-7890');

INSERT INTO Doctor (FName, LName, specialization, phoneNo)
VALUES ('Jane', 'Doe', 'Dermatology', '987-654-3210');

INSERT INTO Doctor (FName, LName, specialization, phoneNo)
VALUES ('Peter', 'Jones', 'Psychiatrist', '555-1212-3333');

INSERT INTO Doctor (FName, LName, specialization, phoneNo)
VALUES ('Mary', 'Brown', 'Pediatrician', '444-555-6666');

INSERT INTO Doctor (FName, LName, specialization, phoneNo)
VALUES ('David', 'Williams', 'Oncologist', '333-222-1111');