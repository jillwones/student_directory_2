# file: app.rb

require_relative 'lib/database_connection'
require_relative 'lib/cohort_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('student_directory_2')

repo = CohortRepository.new 

cohort = repo.find_with_students(1)

p cohort.name 
cohort.students.each { |student| p student.name }

# outputs to terminal:

# "Lions"
# "David"
# "Anna"
# "Jill"