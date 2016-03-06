require "mysql2"
require "pry"

module SimpleOrm

  ## Query Methods ##
  def all(options={})
    result = conn.query("SELECT * FROM #{table_name}")
    objs_array = []
    result.each do |row|
      objs_array << init_for_orm(row)
    end
    objs_array
  end

  def find(id)
    result = conn.query("SELECT * FROM #{table_name} where id = #{id}")
    objs = []
    result.each do |row|
      objs << init_for_orm(row)
    end
    if objs.length == 1
      return objs.first
    else
      return objs # Handles when id isn't unique
    end
  end

  ## Converters ##
  def to_s
    to_h.to_s
  end

  def to_h
    hash = {}
    @column_names.each do |column_name|
      hash[column_name.to_sym] = self.send(column_name)
    end
    hash.to_s
  end

  def column_names
    @column_names
  end

  def column_names=(cns)
    @column_names = cns
  end

  def table_name
    @table_name || self.class.to_s + "s"
  end

  def table_name=(tb_name)
    @table_name = tb_name
  end

  private

  def conn
    @conn ||= get_conn
  end

  def init_for_orm(row)
    new_object = self.class.new
    row.each do |key, value|
      # TODO : check only once
      define_instance_variables_for_class(new_object) unless new_object.respond_to?("#{key}=")
      new_object.send("#{key}=", value)
    end
    return new_object
  end

  def define_instance_variables_for_class(new_object)
    # TODO : SHOW COLUMNS FROM users; row has Field with column name
    result = conn.query("SELECT * FROM #{table_name}")
    row = result.first

    klass = self.class
    new_object.column_names = row.keys
    new_object.column_names.each do |key|
      klass.class_eval do
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
