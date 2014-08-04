require 'spec_helper'
require 'factories/builder'

describe Paynearme::Api::Request::Builder do

  let (:full_builder) {FactoryGirl.build(:full_builder)}
  let (:empty_builder) {FactoryGirl.build(:empty_builder)}

  describe 'Building from a builder' do

    it 'should return a PnmRequest with the created options' do
      expect(full_builder.build.to_s).to include('find_orders', 'version=3.0', 'http://dev.paynearme.com:3000/')
    end

    it 'should return a PnmRequest with the default options (and an method set up by params instead of method)' do
      expect(empty_builder.build.to_s).to include('find_orders', 'version=2.0', 'http://pnm-dev.grio.com:8080/rails40')
    end

  end

end
