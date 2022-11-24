require_relative './cohort'
require_relative './student'

class CohortRepository
  def find_with_students(cohort_id)

    sql = 'SELECT cohorts.id AS cohort_id, cohorts.name AS cohort_name, cohorts.starting_date, students.id, students.name, students.cohort_id
    FROM cohorts
    JOIN students ON students.cohort_id = cohorts.id
    WHERE cohorts.id = $1'
    sql_params = [cohort_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    first_record = result_set[0]
    cohort = Cohort.new 
    cohort.id = first_record['cohort_id']
    cohort.name = first_record['cohort_name']
    cohort.starting_date = first_record['starting_date']

    result_set.each do |record|
      student = Student.new 
      student.id = record['id']
      student.name = record['name']
      student.cohort_id = record['cohort_id']

      cohort.students << student
    end
  return cohort
  end
end