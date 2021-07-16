# Ruby

## Requirements

- Ruby
- Rubygems

Recommended:
- Some sort of ruby versioning control (RVM or rbenv)
- Bundler

## Installation

Without bundler, run these commands (install may require sudo):

    $ git clone git@github.com:paynearme/samplecode-examples.git
    $ cd samplecode-examples/ruby/
    $ gem build pnm_api.gemspec
    $ gem install pnm_api-0.4.0.gem

In a bundler project, simply add:

`gem 'pnm_api', git: 'https://github.com/paynearme/samplecode-examples.git', branch: 'master', glob: 'ruby/*.gemspec'`

to Gemfile and run `bundle install` normally.

## Usage:

With the gem installed your scripts may `require 'paynearme/api'` and use the API client.

Currently the developer is responsible for parsing the output. A simple `JSON.parse(response)` should do it depending on JSON library employed. 

To obtain key/secret for access, visit the developer documentation in the PNM merchant portal. You will also find API 
usage documentation there including required parameters and their description as well as detailed description of returned fields. 

### Examples:

#### Client

```ruby
require 'paynearme'

client = Paynearme::Api::Client.new(secret: 'mysecret', site_identifier: 'S123451234', api_key_id: 'K3436433862', version: '2.0', live: true, format: :json)
response = client.make_call(:find_orders, { site_customer_email: 'yarnosh@gmail.com' })

json = JSON.parse(response)
```

Client defaults to JSON for format but :xml is a valid option. You may also specify a `host:` which will override the `live:` option and should include the desired output format. For example: https://dev.paynearme.com/json-api (JSON) or https://dev.paynearme.com/api (XML)

#### Standalone CLI:

The Gem installs the pnmapi command. Just run: `$ pnmapi help request`
