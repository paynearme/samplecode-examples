require 'spec_helper'

describe Paynearme::Api::Request::PnmRequest do

  let (:pnm_request) {Paynearme::Api::Request::PnmRequest.new(:method => 'find_orders', :host => 'http://dev.paynearme.com:3000/', :secret => 'secret', :params => {:testparam => 'hello', :order_id => '1234', :body_text => 'This is some body text with spaces in it.'})}

  describe 'query' do

    it 'should return a string with all of the param options' do
      expect(pnm_request.query).to include('testparam=hello', 'order_id=1234')
    end

  end

  describe 'sign!' do

    it 'should add a timestamp, version, and signature'do
      pnm_request.sign!
      expect(pnm_request.params.to_s).to include('timestamp', 'signature', 'version')
    end

  end

  describe 'to_s' do

    it 'should return a string with host, method and the query' do
      expect(pnm_request.to_s).to include('find_orders', 'version=2.0', 'http://dev.paynearme.com:3000/', 'testparam=hello')
    end

    it 'should escape appropriate characters' do
      expect(pnm_request.to_s).to match(/This%20is%20some%20body%20text%20with%20spaces%20in%20it./)
    end

  end



end
