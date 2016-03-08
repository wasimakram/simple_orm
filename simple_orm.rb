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
    hash
  end

  ## Class Methods ##
  def self.included(base)
    base.extend SimpleOrm::ClassMethods
  end

  module ClassMethods
    def self.extended(orm_base)
      orm_base.setup
    end

    ## Associations ##
    def has_one(association)
      # TODO : test if rails is present use String#classify
      class_name = association.to_s.split('_').collect!{ |w| w.capitalize }.join
      klass = Object.const_get(class_name)

      define_method(association) do
        klass.find self.send("#{association}_id")
      end
    end

    ## Query Methods ##
    def find(id)
      result = query("SELECT * FROM #{@@table_name} where id = #{id}")
      return initialize_for_orm(result.first) if result.first
    end

    def all(options={})
      result = query("SELECT * FROM #{@@table_name}")
      objs_array = []
      result.each do |row|
        objs_array << initialize_for_orm(row)
      end
      return objs_array
    end

    # TODO : WIP
    def where(id)
      result = query("SELECT * FROM #{@@table_name} where id = #{id}")
      objs = []
      result.each do |row|
        objs << initialize_for_orm(row)
      end
      objs
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
      @@column_names.each do |key|
        class_eval do
          define_method(key) { instance_variable_get("@#{key}"); }
          define_method("#{key}=") { |attr_value| instance_variable_set("@#{key}", attr_value); }
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
