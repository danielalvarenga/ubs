# frozen_string_literal: true

class Scores < ApplicationRecord

  validates :size, :adaptation_for_seniors, :medical_equipment, :medicine, numericality: {
    greater_than_or_equal_to: 1, less_than_or_equal_to: 3, only_integer: true
  }, allow_nil: true

  belongs_to :health_basic_unit

end
