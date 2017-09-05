require_relative 'db_connection'
require 'active_support/inflector'
require_relative 'associatable'
require_relative 'searchable'


class SQLObject
  extend Associatable
  extend Searchable

  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL

    @columns.first.map! { |el| el.to_sym }
  end

  def self.finalize!
    self.columns.each do |col_name|
      # getter
      define_method(col_name) { self.attributes[col_name] }
      # setter
      define_method("#{col_name}=") { |val| self.attributes[col_name] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    rows = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL



    return nil if rows.nil?

    self.parse_all(rows)
  end

  def self.parse_all(results)
    output = []
    results.each do |row|
      output << self.send(:new, row)
    end
    output
  end

  def self.find(id)
    row = DBConnection.execute(<<-SQL, id)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = ?
    SQL

    row.empty? ? nil : self.send(:new, row.first)
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise Exception, "unknown attribute '#{attr_name}'"
      else
        self.send("#{attr_name}=", value)
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    values = []

    self.class.columns.each do |col_name|
      values << self.send("#{col_name}")
    end

    values
  end

  def insert
    # insert row into database
    col_names = self.class.columns.drop(1).join(',')
    question_marks = (["?"] * self.class.columns.drop(1).length).join(',')

    DBConnection.execute(<<-SQL, *self.attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL


    # update id instance variable
    self.attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    update_template = self.class.columns.drop(1).map do |col_name|
                        "#{col_name} = ?"
                      end.join(',')


    DBConnection.execute(<<-SQL, *self.attribute_values.drop(1) ,self.attributes[:id])
      UPDATE
        #{self.class.table_name}
      SET
        #{update_template}
      WHERE
        #{self.class.table_name}.id = ?
    SQL

  end

  def save
    self.class.find(self.id).nil? ? self.insert : self.update
  end
end
