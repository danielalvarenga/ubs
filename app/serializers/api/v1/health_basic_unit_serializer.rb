# frozen_string_literal: true

class Api::V1::HealthBasicUnitSerializer < Api::V1::ApiSerializer

  attributes :id, :name, :address, :city, :phone, :geocode
  has_one :scores

  def address
    object.address&.street
  end

  def city
    object.address&.city
  end

  def geocode
    { lat: object.address.latitude, long: object.address.latitude } if object.address
  end

end
