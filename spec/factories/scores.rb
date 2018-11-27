# frozen_string_literal: true

FactoryBot.define do
  factory :scores do
    size { Faker::Number.between(1, 3) }
    adaptation_for_seniors { Faker::Number.between(1, 3) }
    medical_equipment { Faker::Number.between(1, 3) }
    medicine { Faker::Number.between(1, 3) }

    trait :with_hbu do
      after(:build) do |scores, _evaluator|
        scores.health_basic_unit = create(:valid_hbu)
      end
    end

    factory :valid_scores, traits: [:with_hbu]
    factory :scores_without_hbu, traits: []
  end
end
