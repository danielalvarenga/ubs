# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'get response from unmatched route', type: :request do
  before do
    get '/abcde'
  end

  it 'responds with 404 status' do
    expect(response).to have_http_status(404)
  end

  it 'check the json response' do
    expect(json[:status]).to eq('route_not_found')
  end
end
