# Ruby

## Requirements

- Ruby
- Rubygems

Recommended:
- Some sort of ruby versioning control (RVM or rbenv)
- Bundler

## Installation

Without bundler, run this command (may require sudo):

    $ git clone git@github.com:paynearme/samplecode-examples.git
    $ cd samplecode-examples/ruby/
    $ gem build pnm_api.gemspec

This builds a gem named pnm_api-0.3.0.gem which you can now bundle install

## Usage:

With the gem installed your scripts may `require 'paynearme/api'` and use the provided request helpers.

### Example:

```ruby
# The supporting classes and methods are part of the pnm-examples git repository
# https://github.com/paynearme/samplecode-examples

require 'httparty'
require 'paynearme/api/request'

request = Paynearme::Api::Request::Builder.new(host: "http://paynearmehost.tld/api", 
  method: 'find_orders', secret: 'TOP_SECRET_KEY', version: '2.0') do |r|
  r.param :site_identifier, 'my_site_id'
  r.param :version, '2.0'
  r.param :timestamp, Time.now.to_i.to_s
end

url = request.build.to_s

puts "Request url: #{url}"
puts HTTParty.get url
```
