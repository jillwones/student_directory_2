# Cohort Model and Repository Classes Design Recipe

## 1. Design and create the Table

```
Table: cohorts

Columns:
id | name | starting_date
```

## 2. Create Test SQL seeds

```sql
TRUNCATE TABLE students, cohorts RESTART IDENTITY; 

INSERT INTO cohorts (name, starting_date) VALUES('Tigers', 'November 2022');
INSERT INTO cohorts (name, starting_date) VALUES('Lions', 'December 2022');

INSERT INTO students (name, cohort_id) VALUES ('David', 1);
INSERT INTO students (name, cohort_id) VALUES ('Anna', 1);
INSERT INTO students (name, cohort_id) VALUES ('Jill', 1);
INSERT INTO students (name, cohort_id) VALUES ('Fred', 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
class Cohort
end

class CohortRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class Cohort
  attr_accessor :id, :name, :starting_date, :students
  def initialize
    @students = []
  end
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

```ruby
class CohortRepository
  def find_with_students(cohort_id)
    # Executes the SQL query:
    'SELECT cohorts.id AS cohort_id, cohorts.name AS cohort_name, cohorts.starting_date, students.id, students.name, students.cohort_id
    FROM cohorts
    JOIN students ON students.cohort_id = cohorts.id
    WHERE cohorts.id = $1'
    # returns a cohort object
    # with an array of student objects
end
```

## 6. Write Test Examples

```ruby
# 1
# finds cohort with relevant students

repo = CohortRepository.new

cohort = repo.find_with_students(1)

expect(cohort.name).to eq('Tigers')
expect(cohort.starting_date).to eq('2022-11-01')

expect(cohort.students.length).to eq(3)
expect(cohort.students.first.name).to eq('David')
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'student_directory_2_test' })
  connection.exec(seed_sql)
end

describe CohortRepository do
  before(:each) do 
    reset_tables
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
