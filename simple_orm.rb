require "mysql2"
require "pry"

module SimpleOrm

  def all(options={})
    result = conn.query("SELECT * FROM #{self.class.to_s}s")
    objs_array = []
    result.each do |row|
      objs_array << init_for_orm(row)
    end
    objs_array
  end

  def find(id)
    result = conn.query("SELECT * FROM #{self.class.to_s}s where id = #{id}")
    obj = []
    result.each do |row|
      obj << init_for_orm(row)
    end
    if obj.length == 1
      return obj.first
    else
      return obj
    end
  end


  def conn
    @conn ||= get_conn
  end

  private

  def init_for_orm(row)
    define_instance_variables_for_class(row)
    new_object = self.class.new
    row.each do |key, value|
      new_object.send("#{key}=", value) unless key == "id"
    end
    return new_object
  end

  def define_instance_variables_for_class(row)
    klass = self.class
    row.keys.each do |key|
      klass.define_singleton_method(key) do
        klass.instance_variable_get("@#{key}")
      end
      klass.define_singleton_method("#{key}=") do |attr_value|
        klass.instance_variable_set("@#{key}", attr_value)
      end
    end
  end

  def get_conn
    @db_host  = "127.0.0.1"
    @db_user  = "root"
    @db_password  = ""
    @db_name = "organizations"
    @client = Mysql2::Client.new(
      host: @db_host,
      username: @db_user,
      password: @db_password,
      database: @db_name)
  end

  # @users_result = @client.query("SELECT * FROM users")
  # @employees_result = @client.query("SELECT * FROM employees")
  # @users_result.each { |row| puts row }; nil
  # @employees_result.each { |row| puts row }; nil



end
