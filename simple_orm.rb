require "mysql2"
require "pry"

module SimpleOrm

  ## Instance Methods ##

  ## Converters ##
  def to_s
    to_h.to_s
  end

  def to_h
    hash = {}
    self.class.column_names.each do |column_name|
      hash[column_name.to_sym] = self.send(column_name)
    end
    hash.to_s
  end

  ## Class Methods ##

  def self.included(base)
    base.extend SimpleOrm::ClassMethods
    base.setup
  end

  ## Query Methods ##

  module ClassMethods
    def all(options={})
      result = query("SELECT * FROM #{@@table_name}")
      objs_array = []
      result.each do |row|
        objs_array << initialize_for_orm(row)
      end
      return objs_array
    end

    def find(id)
      result = query("SELECT * FROM #{@@table_name} where id = #{id}")
      objs = []
      result.each do |row|
        objs << initialize_for_orm(row)
      end
      if objs.length == 1
        return objs.first
      else
        return objs # Handles when id isn't unique
      end
    end

    def setup
      @@table_name = self.to_s + "s"
      define_instance_variables_for_class
    end

    def column_names
      @@column_names
    end

    def query(_query)
      puts "Executing SQL: #{_query}"
      conn.query(_query)
    end

    private

    def conn
      @@conn ||= get_conn
    end

    def initialize_for_orm(row)
      new_object = new
      row.each do |key, value|
        new_object.send("#{key}=", value) if new_object.respond_to?("#{key}=")
      end
      return new_object
    end

    def define_instance_variables_for_class
      @@column_names = []
      result = query("SHOW COLUMNS FROM #{@@table_name}")
      result.map{ |r| @@column_names << r["Field"] }
      klass = self
      @@column_names.each do |key|
        class_eval do
          define_method(key) { klass.instance_variable_get("@#{key}"); }
          define_method("#{key}=") { |attr_value| klass.instance_variable_set("@#{key}", attr_value); }
        end
      end
    end

    def get_conn
      db_host  = "127.0.0.1"
      db_user  = "root"
      db_password  = ""
      db_name = "organizations"
      client = Mysql2::Client.new(
        host: db_host,
        username: db_user,
        password: db_password,
        database: db_name)
    end
  end
end
