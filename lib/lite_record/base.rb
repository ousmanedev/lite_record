module LiteRecord
  class Base
    DB = LiteRecord.connection

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

      def find(id)
        new(DB.get_first_row("SELECT * from #{table} where id = ?", id))
      end
      
      def count
        DB.get_first_value("SELECT count(id) from #{table}")
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

    def save
      return self.class.create(attributes) if self['id'].nil?
      
      DB.execute("UPDATE #{self.class.table} SET #{update_fields} WHERE id = #{self['id']}")
      
      true
    end

    def destroy
      DB.execute("DELETE FROM #{self.class.table} WHERE id = #{self['id']}")
    end

    def [](key)
      attributes[key.to_s]
    end

    def []=(key, value)
      attributes[key.to_s] = value
    end

    private

    def update_fields
      attributes.map do |key, value|
        "#{key} = #{self.class.send(:sql_value, value)}"
      end.join(',')
    end
  end
end