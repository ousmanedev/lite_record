module LiteRecord
  class Base
    DB = LiteRecord.connection

    class << self
      attr_accessor :table

      def create(data)
        data.delete('id')
        columns = table_columns.join(',')
        values = table_columns.map { |c| convert(data[c]) }.join(',')

        DB.execute("INSERT into #{table}(#{columns}) values(#{values})")
        id = DB.get_first_value("SELECT last_insert_rowid() from #{table}")

        new(table_columns.map { |c| [c, data[c]] }.to_h.merge('id' => id))
      end

      def find(id)
        new(DB.get_first_row("SELECT * from #{table} where id = ?", id))
      end
      
      def count
        DB.get_first_value("SELECT count(id) from #{table}")
      end

      private
      
      def table_columns
        @table_columns ||= (DB.table_info(table).map { |r| r['name'] } - ['id'])
      end

      def convert(value)
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
        "#{key} = #{self.class.send(:convert, value)}"
      end.join(',')
    end
  end
end