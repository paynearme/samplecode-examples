require 'paynearme/api'
require 'digest/md5'

module Paynearme::Api::Request
  class PnmRequest
    REJECT = %i[signature datafile].freeze

    attr_accessor :host, :method, :secret, :version, :params

    def initialize(options={})
      @params  = options[:params] || {}
      @secret  = options[:secret] || ''
      @version = options[:version] || '3.0'
      @host = options[:host] || ''
      @method = options[:method] || ''
    end

    def query
      URI.encode_www_form(@params)
    end

    def url
      "#{host}/#{method}"
    end

    def sign!
      @params[:timestamp] = Time.now.to_i unless @params.has_key? :timestamp
      @params[:version] = @version unless @params.has_key? :version

      str = (params.keys - REJECT).sort.inject('') { |memo, k| "#{memo}#{k}#{params[k]}" }
      @params[:signature] = @version == '3.0' ? OpenSSL::HMAC.hexdigest('sha256', secret, str).downcase : Digest::MD5.hexdigest(str + secret)
    end
  end
end
