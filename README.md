# ROaR-Map
Ruby Object Relational Map, or ROaR-Map for short, is a Ruby wrapper for SQL. The primary motivation behind ROaR-Map is to facilitate the management of SQL databases by allowing developers to use concise Ruby notation rather than clunky SQL commands with minimal loss in power. ROaR-Map is inspired by Ruby on Rails' ActiveRecord.

## Features
- `belongs_to` and `has_many` gives access to many-to-one and one-to-many database relations, respectively
- Basic CRUD actions: `insert`, `update`, and `save`
- Select all the rows from a table with `all` method
- Select specific row from a table with `find` method given the row id as an argument
- `where` takes a hash of parameters to filter db query

## Methods
- `ROaR-Map::columns`
- `ROaR-Map::table_name=` & `ROaR-Map::table_name`
- `ROaR-Map::all`
- `ROaR-Map::insert`
- `ROaR-Map::update`
- `ROaR-Map::save`
- `ROaR-Map::belongs_to`
- `ROaR-Map::has_many`
- `ROaR-Map::has_one_through`


## Setup
1. Make a database using SQL
2. Make a ruby file that contains class wrappers with the following format:
   - Ruby class name should be singular (unlike plural table name) and Upper camel case  
   - Ruby classes inherit from `RoarMap`
3. Write table relations
4. Call finalize! method somewhere in class definition(s)

## Example

```Ruby
class Teacher < RoarMap
  has_many :courses

  finalize!
end

class Course < RoarMap
  belongs_to :teacher
  has_many :students

  finalize!
end

class Student < RoarMap
  belongs_to :course
  has_one_through :teacher, :course, :teacher

  finalize!
end
```

## Demo 
To check out the above example in action
1. cd into the root directory
2. run the following command: `cat school.sql | sqlite3 school.db`
2. Start a REPL session
3. Load `demo.rb`
4. Run commands like `Teacher.all` or try creating a new student object!
