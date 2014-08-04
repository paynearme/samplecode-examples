require 'spec_helper'

describe Paynearme::Api::CLI do

  let (:cli) {Paynearme::Api::CLI.new}

  it 'should put a request' do
    expect {cli.request('find_orders', 'bat=man', 'rob=in')}.to output(/find_orders.*bat=man/).to_stdout
  end

  it 'should put a request with options --execute and --verbose' do
    response = FakeResponse.new
    response.body = 'rocket ships'
    Paynearme::Api::CLI.any_instance.stub(:options).and_return({:execute => true, :verbose => true})
    HTTParty.stub(:get).and_return(response)
    expect {cli.request('find_orders')}.to output(/Method:  find_orders(.*\n)*rocket ships/).to_stdout  # checks if verbose and execute were executed correctly
  end

  it 'should put a version' do
    expect {cli.version}.to output.to_stdout
  end

end