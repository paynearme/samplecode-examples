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

This builds a gem named pnm_api-0.4.0.gem which you can now bundle install

## Usage:

With the gem installed your scripts may `require 'paynearme/api'` and use the provided request helpers.

### Examples:

#### Client

```ruby
require 'paynearme'

client = Paynearme::Api::Client.new(secret: 'mysecret', site_identifier: 'S123451234', api_key_id: 'K3436433862', version: '2.0', live: true, format: :json)
response = client.make_call(:find_orders, { site_customer_email: 'yarnosh@gmail.com' })
```

Client defaults to JSON for format but :xml is a valid option. You may also specify a host: which will override the "live" option and should include the format. For example: https://dev.paynearme.com/json-api or https://dev.paynearme.com/api

#### Standalone CLI:

The Gem installs the pnmapi command. Just run: `$ pnmapi help request`
