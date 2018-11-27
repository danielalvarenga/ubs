# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get 'find_ubs', to: 'health_basic_units#index'
    end
  end

  # Keep in last line unmatched route
  match '*unmatched', to: 'application#route_not_found', via: :all,
                      constraints: ->(req) { req.path.exclude? 'rails/active_storage' }
end
