# frozen_string_literal: true

class Api::V1::ApiController < ApplicationController

  include PaginationHelper

  def render_collection(collection, options = {})
    collection = paginate(collection)
    render json: Api::V1::CollectionSerializer.new(collection, options).serializable_hash
  end

end
