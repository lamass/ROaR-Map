# ROaR-Map
Ruby Object Relational Map, or ROaR-Map for short, is a Ruby wrapper for SQL. The primary motivation behind ROaR-Map is to facilitate the management of SQL databases by allowing developers to use concise Ruby notation rather than clunky SQL commands with minimal loss in power. ROaR-Map is inspired by Ruby on Rails' ActiveRecord.

## Features
- `belongs_to` and `has_many` gives access to many-to-one and one-to-many database relations, respectively
- Basic CRUD actions: `insert`, `update`, and `save`
- Select all the rows from a table with `all` method
- Select specific row from a table with `find` method given the row id as an argument
- `where` takes a hash of parameters to filter db query

## Methods
- `::columns` returns symbol array of table columns
- `::table_name=(string)` sets table name to value of provided string argument
- `::table_name` returns table_name as string
- `::all` returns an array of class instances
- `#insert` inserts new row into table with class instance's attribute values as values.
- `#attributes` returns hash where keys are the table's column names and values are their respective values
- `#attribute_values` returns unsorted array of column values
- `#update` after changing object's attribute values by manipulating hash returned by `#attributes`, update corresponding row in table
- `#save` either inserts or updates row in table depending on presence in database

### `belongs_to`
Arguments: `(name, {class_name: string, primary_key: integer, foreign_key: integer})` 
Takes as arguments a required class name and an optional hash. The method creates a class instance method that fetches the appropiate table relation as an object. Use this method when the given object's table has a foreign key that points to another table's primary key. See the example in the example section below for an example of usage.

### `has_many`
Arguments: `(name, {class_name: string, primary_key: integer, foreign_key: integer})`
Like `belongs_to`, takes as arguments a required class name and an optional hash and creates a class instance method that fetches the appropiate table relation as an object. Use this method when the given object's table has a primary key that other tables' foreign keys point to. See the example in the example section below for an example of usage.

### `has_one_through`
Arguments: `(name, through_name, source_name)`
Takes in three required arguments and creates an instance method that fetches the appropriate distant table relation. Use this method when the given object's table has a foreign key that points to the primary key of the `through_name`'s table, which in turn has a foreign key that points to the primary key of the `source_name`'s table. 


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
