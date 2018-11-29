# frozen_string_literal: true

class Api::V1::HealthBasicUnitSerializer < Api::V1::ApiSerializer

  attributes :id, :name, :address, :city, :phone, :geocode
  has_one :scores, serializer: Api::V1::ScoresSerializer

  def address
    object.address&.street
  end

  def city
    object.address&.city
  end

  def geocode
    { lat: object.address.latitude.to_f, long: object.address.longitude.to_f } if object.address
  end

end
