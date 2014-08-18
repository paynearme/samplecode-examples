require 'paynearme/api'
require 'digest/md5'

module Paynearme::Api::Request
  class PnmRequest
    REJECT = %w(signature datafile).map {|m| m.to_sym }

    attr_accessor :host
    attr_accessor :method
    attr_accessor :secret
    attr_accessor :version
    attr_accessor :params

    def initialize(options={})
      super()
      @params  = options[:params] || {}
      @secret  = options[:secret] || ''
      @version = options[:version] || '2.0'
      @host = options[:host] || ''
      @method = options[:method] || ''
    end

    def query
      @params.map {|k,v| "#{k}=#{v}" }.join '&'
    end

    def sign!
      @params[:timestamp] = Time.now.to_i unless @params.has_key? :timestamp
      @params[:version] = @version unless @params.has_key? :version

      str = (params.keys - REJECT).sort.inject('') {
        |memo, k| "#{memo}#{k}#{params[k]}" 
      }

      @params[:signature] = Digest::MD5.hexdigest(str + secret)
    end

    def to_s
      sign!
      URI.escape("#{host}/#{method}?#{query}")
    end
  end
end