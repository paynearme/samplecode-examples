require 'paynearme'

module Paynearme::Api
  module Request
    autoload :PnmRequest, 'paynearme/api/request/pnm_request'
    autoload :Builder, 'paynearme/api/request/builder'
  end
end