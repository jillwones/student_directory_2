TRUNCATE TABLE students, cohorts RESTART IDENTITY; 

INSERT INTO cohorts (name, starting_date) VALUES('Tigers', '2022-11-01');
INSERT INTO cohorts (name, starting_date) VALUES('Lions', '2022-12-01');

INSERT INTO students (name, cohort_id) VALUES ('David', 1);
INSERT INTO students (name, cohort_id) VALUES ('Anna', 1);
INSERT INTO students (name, cohort_id) VALUES ('Jill', 1);
INSERT INTO students (name, cohort_id) VALUES ('Fred', 2);