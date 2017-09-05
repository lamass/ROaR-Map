require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)

    where_line = params.keys.map do |hash_key|
                   " #{hash_key} = ? "
                 end.join(' AND ')

    query = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

    return nil if query.nil?

    result = []
    query.each do |row|
      result << self.send(:new, row)
    end
    result
  end
end

class SQLObject
  extend Searchable
end
