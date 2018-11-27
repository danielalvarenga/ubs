# frozen_string_literal: true

class HealthBasicUnit < ApplicationRecord

  validates :name, :cnes_code, presence: true
  validates :phone, numericality: { only_integer: true }, allow_nil: true

  has_one :address, dependent: :destroy
  has_one :scores, dependent: :destroy

  scope :by_geocode, ->(lat, long) do
    joins(:address).where(addresses: { latitude: lat, longitude: long })
  end

  def phone=(phone)
    phone = phone.blank? ? nil : phone.gsub(/[^0-9]/, '')
    self[:phone] = phone.presence
  end

end
