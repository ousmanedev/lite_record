require 'sqlite3'

module LiteRecord
  class Base
    DB = SQLite3::Database.new(
      LiteRecord.configuration.database_path,
      results_as_hash: true
    )

    class << self
      attr_accessor :table

      def create(data)
        data.delete('id')
        columns = keys.join(',')
        values = sql_values(data).join(',')

        DB.execute("INSERT into #{table}(#{columns}) values(#{values})")

        id = DB.get_first_value("SELECT last_insert_rowid() from #{table}")

        new(data_hash(data).merge('id' => id))
      end

      private

      def keys
        @keys ||= table_columns - ['id']
      end

      def sql_values(data)
        keys.map { |k| sql_value(data[k]) }
      end

      def data_hash(data)
        keys.map { |k| [k, data[k]] }.to_h
      end

      def table_columns
        @table_columns ||= DB.table_info(table).map { |r| r['name'] }
      end

      def sql_value(value)
        if value.nil?
          'null'
        elsif value.is_a?(String)
          "'#{value}'"
        else
          value
        end
      end
    end

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end
  end
end
