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

### Examples:

#### Client

```ruby
require 'paynearme/api'

client = Paynearme::Api::Client.new(host: 'http://host/api', secret: key2.last, site_identifier: key2.first, version: '2.0')
response = client.make_call(:find_orders, { site_customer_email: 'yarnosh@gmail.com' })
```

#### Standalone CLI:

Create new file with:

```ruby
#!/usr/bin/env ruby

require 'paynearme/api'

Paynearme::Api::CLI.start(ARGV)
```

Then `chmod a+x cli.rb`
