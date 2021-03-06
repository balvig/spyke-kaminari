# Spyke::Kaminari

Makes [Spyke](https://github.com/balvig/spyke) models aware of APIs that return [pagination headers](https://github.com/generalassembly/spyke-kaminari/blob/3674c98990c2d23c7b1b7548ecfd2edae7090056/lib/spyke/kaminari.rb#L4-L12), like those from the [Grape::Kaminari](https://github.com/monterail/grape-kaminari) gem. Inspired by [@DanielBlanco](https://github.com/DanielBlanco)'s [Her::Kaminari](https://github.com/DanielBlanco/her-kaminari).

[![Build Status](https://semaphoreci.com/api/v1/projects/0a78d63e-84b2-40cc-827d-01713bbb2d61/379901/badge.png)](https://semaphoreci.com/generalassembly/spyke-kaminari--2)

## Installation

  1. Add to `Gemfile`:

  ```ruby
  gem 'spyke-kaminari', '~> 0.0.4'
  ```

  2. Add the Faraday middleware:

  ```ruby
    Faraday.new(url: 'http://api.example.org') do |faraday|
      # Request middleware
      # ...

      # Response middleware
      faraday.use Spyke::Kaminari::HeaderParser # <-- right here!
      faraday.use JSONParser

      # Adapter middleware
      # ...
    end
  ```

  3. Include the scopes in your Spyke models:

  ```ruby
  class User < Spyke::Base
    include Spyke::Kaminari::Scopes
  ```

## Usage

### Scopes

```ruby
# Request the second page:
User.page(2)

# Ask for 50 results per page:
User.per_page(50)

# Skip the first 5 records:
User.offset(5)
```

### Helpers

```ruby
# Iterate through each page:
User.all.each_page.map(&:count)
# => [25, 25, 18]

# Stitch together an array of all records:
users = User.all.each_page.flat_map(&:to_a)
users.count
# => 68
```

### Metadata

```ruby
User.all.total_count  # => 68
User.all.total_pages  # => 3
User.all.limit_value  # => 25
User.all.current_page # => 1
User.all.next_page    # => 2
User.all.prev_page    # => nil
User.all.offset_value # => 0
```
