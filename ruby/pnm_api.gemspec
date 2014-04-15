# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paynearme/api/version'

Gem::Specification.new do |spec|
  spec.name          = "pnm_api"
  spec.version       = Paynearme::Api::VERSION
  spec.authors       = ["ryands"]
  spec.email         = ["rschultz@grio.com"]
  spec.summary       = %q{Library for building PNM API calls, and a cli tool to help}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty'
  spec.add_dependency 'thor'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
