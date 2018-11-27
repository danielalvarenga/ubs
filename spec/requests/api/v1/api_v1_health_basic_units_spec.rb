# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::HealthBasicUnits', type: :request do
  describe 'GET /api/v1/find_ubs' do
    it 'works!' do
      get api_v1_find_ubs_path
      expect(response).to have_http_status(200)
    end
  end
end
