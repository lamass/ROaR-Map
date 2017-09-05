require_relative './lib/sql_object'

class Teacher < SQLObject
  has_many :courses

  finalize!
end

class Course < SQLObject
  belongs_to :teacher
  has_many :students

  finalize!
end

class Student < SQLObject
  belongs_to :course
  has_one_through :teacher, :course, :teacher

  finalize!
end
