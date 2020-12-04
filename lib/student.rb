# frozen_string_literal: true

class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      create table students (
        id INTEGER PRIMARY KEY,
        name text,
        grade text
      )

    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      drop table students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      insert into students (name,grade)
      values(?,?)
    SQL
    DB[:conn].execute(sql, name, grade)
    @id = DB[:conn].execute('select last_insert_rowid() from students')[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end
