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
    application_status VARCHAR(50)CHECK (application_status IN ('Pending', 'Accepted', 'Rejected')),
    PRIMARY KEY (application_id, job_id),
    FOREIGN KEY (application_id) REFERENCES application_information(application_id),
    FOREIGN KEY (job_id) REFERENCES job_post(job_id)
);

--建立職缺
INSERT INTO job_post (employer_id, title, job_location, salary, job_description, status)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING job_id;
------------------

--展示申請的狀態
SELECT a.application_id, a.job_id, a.application_status
FROM user_information AS ui
JOIN application_information AS ai ON ui.user_id = ai.user_id
Join application AS a ON a.application_id = ai.application_id
where ui.account = $1;
-----------------------------------------
--展示user的application
SELECT a.job_id, ui.first_name, ui.last_name, ai.education, ai.work_experience, ai.expected_job, ai.other_information, a.application_status
FROM user_information AS ui
JOIN application_information AS ai ON ai.user_id = ui.user_id
JOIN application AS a ON a.application_id = ai.application_id
WHERE ui.user_id = $1 AND  a.job_id = $2;
---------------------------------

--展示job的資訊
SELECT jp.job_id, jp.title, jp.status, jp.salary, jp.job_location, jp.job_description, jp.benefits, jp.other_information, a.application_status
FROM job_post AS jp
JOIN employer_information AS ei ON jp.employer_id = ei.employer_id
LEFT Join application AS a ON a.job_id = jp.job_id
where ei.account = $1;
-----------------------------------------

-- 接受某個申請
UPDATE application
SET application_status = 'Accepted'
WHERE application_id = 7 AND job_id = 10;

-- 同時關閉
UPDATE job_post
SET status = 'Closed'
WHERE job_id = 10;
------------------------------------------

-- 拒絕某個申請
UPDATE application
SET application_status = 'Rejected'
WHERE application_id = 7 AND job_id = 10;

------------------------------------------

--刪除某雇主的某職缺 job_post

-- 刪除申請這份工作的資料：
DELETE FROM application
USING job_post AS jp
WHERE application.job_id = jp.job_id AND jp.job_id = $1 jp.employer_id = $2;

-- 刪除 job_post：
DELETE FROM job_post
WHERE job_id = $1 AND employer = $2;

--------------------------------------------

--job open 1
UPDATE job_post
SET status = 'Open'
WHERE job_id = 10;
--job open 2
UPDATE job_post AS jp
SET status = 'Open'
FROM employer_information AS ei
WHERE jp.job_id = 10 AND jp.employer_id = ei.employer_id AND ei.account = 'abc';
-------------------------------------------------------------------------------

--job closed 1
UPDATE job_post
SET status = 'Closed'
WHERE job_id = 10;
--job open 2
UPDATE job_post AS jp
SET status = 'Closed'
FROM employer_information AS ei
WHERE jp.job_id = 10 AND jp.employer_id = ei.employer_id AND ei.account = 'abc';
