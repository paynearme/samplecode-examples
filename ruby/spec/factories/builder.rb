FactoryBot.define do
  factory :full_builder, class: 'Paynearme::Api::Request::Builder'  do
    after(:build) do |b|
      b.method('find_orders')
      b.version('2.0')
      b.host('http://dev.paynearme.com:3000/api')
      b.secret('===SECRET===')
    end
  end

  factory :empty_builder, class: 'Paynearme::Api::Request::Builder'  do
    after(:build) do |b|
      b.param 'method', 'find_orders'
    end
  end
end
