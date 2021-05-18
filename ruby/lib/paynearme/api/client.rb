require 'paynearme/api'
require 'httparty'

module Paynearme::Api
  class Client
    def initialize(secret:, site_identifier:, version: '3.0', host:)
      @secret = secret
      @site_identifier = site_identifier
      @version = version
      @host = host
    end

    def make_call(method, params)
      builder = Paynearme::Api::Request::Builder.new(host: @host, method: method, secret: @secret, version: @version) do |r|
        r.param :site_identifier, @site_identifier
        r.param :version, @version
        r.param :timestamp, Time.now.to_i.to_s

        params.each do |k, v|
          r.param k, v
        end
      end

      request = builder.build
      @version == '3.0' ? HTTParty.post(request.url, body: request.query) : HTTParty.get([request.url, request.query].join('?'))
    end
  end
end
  