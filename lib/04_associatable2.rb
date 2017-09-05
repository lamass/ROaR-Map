require_relative '03_associatable'




module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      source_table = source_options.table_name

      through_id = self.send(through_options.foreign_key)
      rows = DBConnection.execute(<<-SQL, through_id)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{source_table}.#{source_options.primary_key} = #{through_table}.#{source_options.foreign_key}
        WHERE
          #{through_table}.#{through_options.primary_key} = ?
      SQL

      # parse_all
      source_options.model_class.send(:parse_all, rows).first
    end
  end
end
