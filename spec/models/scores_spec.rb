# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scores, type: :model do
  it { should belong_to(:health_basic_unit).required }
  it { should allow_value(nil).for(:size) }
  it { should allow_value(nil).for(:adaptation_for_seniors) }
  it { should allow_value(nil).for(:medical_equipment) }
  it { should allow_value(nil).for(:medicine) }

  it {
    should validate_numericality_of(:size)
      .is_less_than_or_equal_to(3).is_greater_than_or_equal_to(1).only_integer
  }

  it {
    should validate_numericality_of(:adaptation_for_seniors)
      .is_less_than_or_equal_to(3).is_greater_than_or_equal_to(1).only_integer
  }

  it {
    should validate_numericality_of(:medical_equipment)
      .is_less_than_or_equal_to(3).is_greater_than_or_equal_to(1).only_integer
  }

  it {
    should validate_numericality_of(:medicine)
      .is_less_than_or_equal_to(3).is_greater_than_or_equal_to(1).only_integer
  }

  it 'id is a uuid string' do
    scores = create(:valid_scores)
    expect(scores.id).to be_a(String)
  end
end
