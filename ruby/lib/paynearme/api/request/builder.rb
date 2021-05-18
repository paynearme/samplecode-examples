require 'paynearme/api'

module Paynearme::Api::Request
  class Builder
    def initialize(options={})
      opts = default_options.merge(options)
      @secret = opts[:secret]
      @method = opts[:method]
      @host = opts[:host]
      @version = opts[:version]

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
        version: '2.0',
        timestamp: Time.now.to_i,
        secret: '',
        host: 'http://pnm-dev.grio.com:8080/rails40'
      }
    end
  end
end