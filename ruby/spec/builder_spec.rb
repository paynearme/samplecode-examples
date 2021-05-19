require 'spec_helper'
require 'factories/builder'

describe Paynearme::Api::Request::Builder do
  let(:full_builder) {FactoryBot.build(:full_builder)}
  let(:empty_builder) {FactoryBot.build(:empty_builder)}

  describe 'Building from a builder' do
    it 'should return a PnmRequest with the created options' do
      request = full_builder.build
      expect(request.url).to include('find_orders', 'http://dev.paynearme.com:3000/')
      expect(request.query).to include('version=2.0')
    end

    it 'should return a PnmRequest with the default options (and an method set up by params instead of method)' do
      request = empty_builder.build
      expect(request.url).to include('find_orders', 'http://pnm-dev.grio.com:8080/rails40')
      expect(request.query).to include('version=3.0')
    end
  end
end
