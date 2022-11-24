require 'cohort_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'student_directory_2_test' })
  connection.exec(seed_sql)
end

describe CohortRepository do
  before(:each) do 
    reset_tables
  end

  it 'finds a cohort and its relevant students' do 
    repo = CohortRepository.new

    cohort = repo.find_with_students(1)

    expect(cohort.name).to eq('Tigers')
    expect(cohort.starting_date).to eq('2022-11-01')

    expect(cohort.students.length).to eq(3)
    expect(cohort.students.first.name).to eq('David')
  end
end