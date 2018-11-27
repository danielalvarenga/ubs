# frozen_string_literal: true

module PaginationHelper
  include ActiveSupport::Concern

  def paginate(collection)
    return collection unless collection.respond_to?(:paginate)

    paginate_params = params.to_unsafe_h.slice(:page, :per_page)
    paginate_params[:page] ||= 1
    collection.paginate(paginate_params)
  end
end
