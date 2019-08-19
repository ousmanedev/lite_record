# LiteRecord
Experimental basic ORM in Ruby that only support SQLite3.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lite_record'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lite_record

## Configuration
```ruby
require 'lite_record'

LiteRecord.configure('path_to_sqlite3_database.db')
```

## API
Create a model class that inherits from `LiteRecord::Base` and that's it.
```ruby
# Table: users(id, name, email)

class User < LiteRecord::Base
  self.table = 'users'
end

u = User.create('name' => 'john', 'email'=> 'john@example.com') # creates a database record
u['name'] = 'wick'
u.save # update the user with the new name in the database

u = User.find(1) # query the user with id = 1
u = User.new('name' => 'foo') # creates a user object
u['email'] = 'foo@example.com'
u.save # creates a user record # Creates a database record
```

## Contributing
You're more than welcome to improve this work.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).