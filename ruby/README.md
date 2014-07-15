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

##### Important
  You must lookup the pnm_payment_identifier in your business system and prevent double posting. In the event of a duplicate callback from PayNearMe ( this can sometimes happen in a race or retry condition) you must respond to all duplicates, but do not post the payment.

  No stub code is provided for this check, and is left to the responsibility of the implementor.

  Now that you have responded to a /confirm, you need to keep a record of this pnm_payment_identifier.

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
