require 'factory_bot'
require 'simplecov'
require 'paynearme'
SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

class FakeResponse
  attr_accessor :body
end
