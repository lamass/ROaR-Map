require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    if self.class_name.to_s == 'Human'
      'humans'
    else
      self.class_name.to_s.tableize
    end
  end

end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      class_name: name.to_s.camelcase,
      primary_key: :id,
      foreign_key: ("#{name}_id").to_sym
    }

    options = defaults.merge(options)

    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      class_name: name.to_s.singularize.camelcase,
      primary_key: :id,
      foreign_key: (self_class_name.downcase.to_s + "_id").to_sym
    }

    options = defaults.merge(options)

    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      foreign_value = self.send(options.foreign_key)
      options
        .model_class
        .where(options.primary_key => foreign_value)
        .first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      self_id = self.id

      options
        .model_class
        .where(options.foreign_key => self_id)
    end
  end

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

  private

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end
