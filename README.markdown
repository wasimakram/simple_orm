# SimpleOrm
A simple Orm inspired by active recrod.

## Getting Starting

1. Install gem

  ```
  # Ruby
  gem install "<GEM_NAME>"

  # For bundler place in Gemfile
  gem "<GEM_NAME>""

  ```
2. Include mixin SimpleOrm
  ```
  include SimpleOrm
  ```

3. Use find and all methods along with defined properties based on column names

## Example

  ```
    class User
    ...
      include SimpleOrm

      # If users table has employee_id they can be fetched by calling has_one method
      has_one :employee
    ...

    # adds the following methods #find, #all and properties and relationships based on the users table.

    # find's the user object with with a given id
    # def self.find(id)
    ...

    # returns an array of objects for the class
    # def self.all
    ...
    end

    user = User.find(1)          # Execute SQL : "Select * from users where id = 1"
    user.username                # get username stored in db
    user.username = "wasimakram" # set instance variable username
    user.save                    # Update user in db using attributes

    user.employee                # returns an employee object

  ###
  ```
