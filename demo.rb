require_relative './lib/sql_object'

class Teacher < SQLObject
  has_many :classes
end

class Class < SQLObject
  belongs_to :teacher
end

class Student < SQLObject
  belongs_to :class
  has_one_through :teacher, :class, :teacher
end
