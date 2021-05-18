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

client = Paynearme::Api::Client.new(host: 'http://host/api', secret: 'mysecret', site_identifier: 'K3436433862', version: '2.0')
response = client.make_call(:find_orders, { site_customer_email: 'yarnosh@gmail.com' })
```

#### Standalone CLI:

The Gem installs the pnmapi command. Just run: `$ pnmapi help request`
