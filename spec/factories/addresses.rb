# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    neighborhood { Faker::Address.community }
    county_code { Faker::Code.nric }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    trait :with_hbu do
      after(:build) do |address, _evaluator|
        address.health_basic_unit = create(:valid_hbu)
      end
    end

    factory :valid_address, traits: [:with_hbu]
    factory :address_without_hbu, traits: []
  end
end
