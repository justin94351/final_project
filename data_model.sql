--展示application的status
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

-- 接受某個application
UPDATE application
SET application_status = 'Accepted'
WHERE application_id = 7 AND job_id = 10;

-- 同時關閉
UPDATE job_post
SET status = 'Closed'
WHERE job_id = 10;
------------------------------------------

-- 拒絕某個application
UPDATE application
SET application_status = 'Rejected'
WHERE application_id = 7 AND job_id = 10;

------------------------------------------

--刪除某雇主的某職缺 job_post

-- 刪除申請這份工作的資料：
DELETE FROM application
USING job_post AS jp
WHERE application.job_id = jp.job_id AND jp.job_id = $1 AND jp.employer_id = $2;

-- 刪除 job_post：
DELETE FROM job_post
WHERE job_id = $1 AND employer_id = $2;

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
------------------------------------------------------------------------------------

--投application
INSERT INTO application(application_id, job_id, application_status)
VALUE ($1, $2, 'Pending');

--employer login establish
INSERT INTO employer_login(account, password)
VALUE ($1, $2);

--employer information
INSERT INTO employer_information(account, company_name, established_year, company_address, contact)
VALUE ($1, $2, $3, $4, $5)

--user login establish
INSERT INTO user_login(account, password)
VALUE ($1, $2);

--user information
INSERT INTO user_information(account, last_name, first_name, age, gender, certificate, phone)
VALUE ($1, $2, $3, $4, $5, $6, $7);

--建立application
INSERT INTO application_information(user_id, education, work_experience, expected_job)
VALUE ($1, $2, $3, $4)
RETURNING application_id;

--建立job
INSERT INTO job_post (employer_id, title, job_location, salary, job_description, status)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING job_id;