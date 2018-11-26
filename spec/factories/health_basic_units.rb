# frozen_string_literal: true

FactoryBot.define do
  factory :health_basic_unit do
    name { Faker::Company.name }
    cnes_code { Faker::Code.nric }
    phone { Faker::PhoneNumber.cell_phone }

    factory :valid_hbu
  end
end
