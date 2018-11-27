# frozen_string_literal: true

FactoryBot.define do
  factory :health_basic_unit do
    name { Faker::Company.name }
    cnes_code { Faker::Code.nric }
    phone { Faker::PhoneNumber.cell_phone }

    trait :with_address do
      after(:build) do |hbu, _evaluator|
        hbu.address = build(:address_without_hbu)
      end
    end

    trait :with_scores do
      after(:build) do |hbu, _evaluator|
        hbu.scores = build(:scores_without_hbu)
      end
    end

    factory :valid_hbu
    factory :complete_hbu, traits: %i[with_address with_scores]
  end
end
