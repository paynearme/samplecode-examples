require 'spec_helper'

describe Paynearme::Api::Client do
  subject { Paynearme::Api::Client }

  describe 'make_call' do
    it 'should request sandbox service by default' do
      client = subject.new(secret: '==SECRET==', api_key_id: 'K1234', version: '2.0', site_identifier: 'S56789')
      expect(HTTParty).to receive(:get).with(/sandbox/)
      client.make_call(:find_orders, site_customer_email: 'yarnosh@gmail.com')
    end

    it 'should request live service upon request' do
      client = subject.new(secret: '==SECRET==', api_key_id: 'K1234', version: '2.0', site_identifier: 'S56789', live: true)
      expect(HTTParty).to receive(:get).with(/www\.paynearme/)
      client.make_call(:find_orders, site_customer_email: 'yarnosh@gmail.com')
    end

    it 'should request xml upon request' do
      client = subject.new(secret: '==SECRET==', api_key_id: 'K1234', version: '2.0', site_identifier: 'S56789', live: true, format: :xml)
      expect(HTTParty).to receive(:get).with(/\/api/)
      client.make_call(:find_orders, site_customer_email: 'yarnosh@gmail.com')
    end

    it 'should request json by default' do
      client = subject.new(secret: '==SECRET==', api_key_id: 'K1234', version: '2.0', site_identifier: 'S56789', live: true)
      expect(HTTParty).to receive(:get).with(/\/json\-api/)
      client.make_call(:find_orders, site_customer_email: 'yarnosh@gmail.com')
    end

    it 'should send POST for v3.0' do
      client = subject.new(secret: '==SECRET==', api_key_id: 'K1234', version: '3.0', site_identifier: 'S56789', live: true)
      expect(HTTParty).to receive(:post).with(/\/json\-api/, { body: /S56789/ })
      client.make_call(:find_orders, site_customer_email: 'yarnosh@gmail.com')
    end
  end
end
