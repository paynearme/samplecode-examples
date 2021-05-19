require 'spec_helper'

describe Paynearme::Api::Request::PnmRequest do
  let(:pnm_request) {Paynearme::Api::Request::PnmRequest.new(method: 'find_orders', host: 'http://dev.paynearme.com:3000/api', secret: 'secret', params: {:testparam => 'hello', :order_id => '1234', :body_text => 'This is some body text with spaces in it.'})}

  before do
    pnm_request.sign!
  end

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

  describe 'url + query' do
    it 'should be a string with host, method and the query' do
      expect("#{pnm_request.url}?#{pnm_request.query}").to include('find_orders', 'version=3.0', 'http://dev.paynearme.com:3000/', 'testparam=hello')
    end

    it 'should escape appropriate characters' do
      expect(pnm_request.query).to match(/This\+is\+some\+body\+text\+with\+spaces\+in\+it\./)
    end
  end
end
