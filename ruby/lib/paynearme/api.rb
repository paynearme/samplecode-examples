require 'paynearme'

module Paynearme::Api
  autoload :Client, 'paynearme/api/client'
  autoload :Request, 'paynearme/api/request'
  autoload :VERSION, 'paynearme/api/version'
  autoload :CLI, 'paynearme/api/cli'
end