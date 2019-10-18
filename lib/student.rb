require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :id, :name, :grade
  
  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    if @id == nil
      insert_instance_into_database
    else
      update_existing_database_item
    end
  end

  def update_existing_database_item
    sql = "UPDATE students SET name = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.id)  
  end

  def insert_instance_into_database
    sql = "INSERT INTO students(name, grade) VALUES (?, ?)"
    DB[:conn].execute(sql, @name, @grade)
    sql = "SELECT * FROM students ORDER BY id DESC LIMIT 1"
    ret = DB[:conn].execute(sql)[0] 
    @id = ret[0] 
    self 
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)"
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    brand_new_student = Student.new(name, grade)
    brand_new_student.save
  end

  def self.new_from_db(row)
    brand_new_student = Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    found_student_array = DB[:conn].execute(sql, name)[0]
    new_from_db(found_student_array)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def update
    update_existing_database_item
  end

end
