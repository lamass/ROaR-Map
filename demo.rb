require_relative './lib/roar_map'

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
