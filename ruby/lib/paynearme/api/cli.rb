require 'paynearme'

require 'thor'
require 'httparty'

module Paynearme::Api
  class CLI < Thor
    class_option :host, aliases: [:h], default: 'http://paynearmeservers.tld/api', desc: 'API Host'
    class_option :secret, aliases: [:s], default: 'suprsecret', desc: 'Secret key'
    class_option :version, aliases: [:v], default: '2.0', desc: 'Version'
    class_option :verbose, default: false, desc: 'Verbose output', type: :boolean

    desc 'request <method> [args]', 'Perform a request'
    option :execute, aliases: [:e], default: false, desc: 'Execute request', type: :boolean
    def request(method, *args)
      builder = Paynearme::Api::Request::Builder.new do |r|
        r.host options[:host]
        r.method method
        r.secret options[:secret]
        r.version options[:version]

        args.each do |arg|
          a = arg.split '='
          r.param *a
        end
      end

      request = builder.build
      
      if options[:execute]
        url = "#{request.url}?#{request.query}"
        puts "URL: #{url}"
        verbose_output request if options[:verbose]

        response = nil
        t = timer do
          response = options[:version] == '3.0' ? HTTParty.post(request.url, body: request.query) : HTTParty.get(url)
        end

        puts response.body

        puts
        puts "Request completed in #{t.to_f*1000}ms"
        puts "WARNING: Long request (> 6 seconds)" if t.to_i >= 6
      else
        puts request
      end
    end

    desc 'version', 'Version of this tool/pnm_api gem'
    def version
      puts "pnm_api-#{Paynearme::Api::VERSION}"
    end

    private

    def timer(&block)
      start = Time.now
      block.call
      Time.now - start
    end

    def verbose_output(req)
      puts <<-OUTPUT

Host:    #{req.host}
Method:  #{req.method}
Secret:  #{req.secret}
Version: #{req.version}
params:  #{req.params}

      OUTPUT
    end
  end
end