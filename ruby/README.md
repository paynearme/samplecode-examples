# Ruby

## Requirements

- Ruby
- Rubygems

Recommended:
- Some sort of ruby versioning control (RVM or rbenv)
- Bundler

## Installation

Without bundler, run this command (may require sudo):

    $ gem install pnm_api

With bundler:

Add this line to your application's Gemfile:

    gem 'pnm_api'

And then execute:

    $ bundle

## Usage:

With the gem installed your scripts may `require 'paynearme/api'` and use the provided request helpers.

### Example:

```ruby
require 'httparty'
require 'paynearme/api'

request = Paynearme::Api::Request::Builder.new do |r|
    r.host 'http://paynearmehost.tld/api'
    r.method :create_order
    r.secret 'top_secret_code!!!'
    r.version '2.0'

    r.param :site_identifier, 'my_site_id'
    r.param :site_order_identifier, 'ORDER-1929'

    # ...
end

url = request.build.to_s

puts "Request url: #{url}"
puts HTTParty.get url
```