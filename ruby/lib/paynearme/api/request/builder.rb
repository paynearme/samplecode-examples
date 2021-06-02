require 'paynearme/api'

module Paynearme::Api::Request
  class Builder
    def initialize(options={})
      opts = default_options.merge(options)
      @secret = opts[:secret]
      @method = opts[:method]
      @version = opts[:version]
      @format = opts[:format]
      @live = !!opts[:live]
      @host = opts[:host] || get_host

      yield self if block_given?
    end

    def param(key, value)
      @params ||= {}
      @params[key.to_sym] = value
      self
    end

    def method(meth)
      @method = meth
      self
    end

    def host(h)
      @host = h
      self
    end

    def version(v)
      @version = v
      self
    end

    def secret(s)
      @secret = s
      self
    end

    def build
      req = PnmRequest.new(
        host: @host, 
        method: @method, 
        secret: @secret, 
        version: @version,
        params: @params
      )
      req.sign!
      req
    end

    private

    def default_options
      {
        method: :find_orders,
        version: '3.0',
        timestamp: Time.now.to_i,
        secret: '',
        format: :json
      }
    end

    def get_host
      path = @format == :xml ? 'api' : 'json-api'
      @live ? "https://www.paynearme.com/#{path}" : "https://sandbox.paynearme.com/#{path}"
    end
  end
end
