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
    ...

    # adds the following methods #find, #all and properties and relationships based on the users table.

    # find's the user object with with a given id
    # def self.find(id)
    ...

    # returns an array of objects for the class
    # def self.all
    ...
    end

    user = User.find(1) # "Select * from users where id = 1"
    user.username # "will get username stored in db"


  ###
  ```
