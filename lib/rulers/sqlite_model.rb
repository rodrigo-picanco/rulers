require "sqlite3"
require "rulers/utils"

DB = SQLite3::Database.new "test.db"

module Rulers
  module Model
    class SQLite
      def initialize(data = nil)
        @hash = data
      end

      def scope(name, &block)
        define_singleton_method(name, &block)
      end

      def method_missing(name, *args)
        if @hash.key?(name.to_s)
          define_singleton_method(name) do
            @hash[name.to_s]
          end
          @hash[name.to_s]
        else
          super
        end
      end

      def respond_to_missing?(name, include_private = false)
        @hash.key?(name.to_s) || super
      end

      def self.to_sql(val)
        case val
        when NilClass
          "null"
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL!"
        end
      end

      def self.create(values)
        puts "CREATE: #{values}"
        values.delete "id"
        keys = schema.keys - ["id"]
        vals = keys.map do |key|
          values[key.to_sym] ? to_sql(values[key.to_sym]) : "null"
        end

        puts "INSERT INTO #{table} (#{keys.join ","}) VALUES (#{vals.join ","})"

        DB.execute <<-SQL
          INSERT INTO #{table} (#{keys.join ","})
            VALUES (#{vals.join ","})
        SQL

        raw_vals = keys.map { |k| values[k.to_sym] }
        data = Hash[keys.zip raw_vals]
        sql = "SELECT last_insert_rowid();"
        data["id"] = DB.execute(sql)[0][0]
        new data
      end

      def self.count
        DB.execute(<<-SQL)[0][0]
          SELECT COUNT(*) FROM #{table}
        SQL
      end

      def self.find(id)
        row = DB.execute <<-SQL
        select #{schema.keys.join ","} from #{table} where id = #{id};
        SQL
        data = Hash[schema.keys.zip row[0]]
        new data
      end

      def self.all
        rows = DB.execute <<-SQL
          select #{schema.keys.join ","} from #{table}
        SQL

        rows.map do |row|
          new Hash[schema.keys.zip row]
        end
      end

      def save!
        fields = @hash.map do |k, v|
          "#{k}=#{self.class.to_sql(v)}"
        end.join ","
        DB.execute <<-SQL
          UPDATE #{self.class.table}
          SET #{fields}
          WHERE id = #{@hash["id"]}
        SQL
        true
      end

      def save
        save!
      rescue StandardError
        false
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
        define_method(name.to_s) { value }
      end

      def self.table
        Rulers.to_underscore name
      end

      def self.schema
        return @schema if @schema

        @schema = {}
        DB.table_info(table) do |row|
          @schema[row["name"]] = row["type"]
        end
        @schema
      end
    end
  end
end
