 "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres 
 CREATE DATABASE job;
 \c job

 CREATE TABLE user_login(
    account VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL
 );

 CREATE TABLE user_information(
    user_id SERIAL PRIMARY KEY,
    account VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    certificate VARCHAR(255),
    phone VARCHAR(20),
    FOREIGN KEY (account) REFERENCES user_login(account)
 );

 CREATE TABLE application_information(
    application_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    education VARCHAR(255),
    work_experience VARCHAR(255),
    expected_job VARCHAR(255),
    other_information TEXT,
    FOREIGN KEY (user_id) REFERENCES user_information(user_id)
 );

 CREATE TABLE employer_login(
    account VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL
 );

CREATE TABLE employer_information(
    employer_id SERIAL PRIMARY KEY,
    account VARCHAR(50) NOT NULL,
    company_name VARCHAR(255),
    established_year INT,
    company_address VARCHAR(255),
    contact VARCHAR(50),
    FOREIGN KEY (account) REFERENCES employer_login(account)
);

CREATE TABLE job_post(
    job_id SERIAL PRIMARY KEY,
    employer_id INT NOT NULL,
    title VARCHAR(255),
    status VARCHAR(50),
    salary VARCHAR(50),
    job_description TEXT,
    job_location VARCHAR(255),
    benefits TEXT,
    other_information TEXT,
    FOREIGN KEY (employer_id) REFERENCES employer_information(employer_id)
);

CREATE TABLE application(
    application_id INT NOT NULL,
    job_id INT NOT NULL,
    application_status VARCHAR(50) CHECK (application_status IN ('Pending', 'Accepted', 'Rejected')),
    PRIMARY KEY (application_id, job_id),
    FOREIGN KEY (application_id) REFERENCES application_information(application_id),
    FOREIGN KEY (job_id) REFERENCES job_post(job_id)
);
