FactoryBot.define do
  factory :scores do
    size { Faker::Number.between(1, 3) }
    adaptation_for_seniors { Faker::Number.between(1, 3) }
    medical_equipment { Faker::Number.between(1, 3) }
    medicine { Faker::Number.between(1, 3) }

    after(:build) do |scores, _evaluator|
      scores.health_basic_unit = create(:valid_hbu)
    end

    factory :valid_scores
  end
end
