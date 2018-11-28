# frozen_string_literal: true

class Api::V1::HealthBasicUnitsController < Api::V1::ApiController

  def index
    @hbus = HealthBasicUnit.includes(:address, :scores)
    if params[:query]
      query = params[:query].split(',')
      @hbus = @hbus.by_geocode(query.first, query.last)
    end
    render_collection @hbus, each_serializer: Api::V1::HealthBasicUnitSerializer
  end

end
