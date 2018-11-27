# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::HealthBasicUnitsController, type: :controller do
  describe 'GET #index' do
    before(:context) do
      @hbus = create_list(:complete_hbu, 19)
    end

    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_successful
    end

    context 'valid pagination' do
      it 'when default' do
        get :index
        expect(json[:entries].size).to eq(10)
        expect(json[:current_page]).to eq(1)
        expect(json[:per_page]).to eq(10)
      end

      it 'when per page 5' do
        get :index, params: { per_page: 5 }
        expect(json[:entries].size).to eq(5)
        expect(json[:per_page]).to eq(5)
        expect(json[:total_pages]).to eq(4)
      end

      it 'when page 2' do
        get :index, params: { page: 2 }
        expect(json[:entries].size).to eq(9)
        expect(json[:current_page]).to eq(2)
      end

      it 'when page 3' do
        get :index, params: { page: 3 }
        expect(json[:entries].size).to eq(0)
        expect(json[:current_page]).to eq(3)
      end

      it 'when returns total pages' do
        get :index
        expect(json[:total_pages]).to eq(2)
      end

      it 'when returns total entries' do
        get :index
        expect(json[:total_entries]).to eq(19)
      end
    end

    context 'valid search' do
      it 'when find by latitude and longitude' do
        hbu = @hbus.sample
        get :index, params: { query: "#{hbu.address.latitude},#{hbu.address.longitude}" }
        expect(json[:entries].size).to eq(1)
        expect(json[:entries].first[:id]).to eq(hbu.id)
      end
    end

    it 'returns serialized entries' do
      get :index
      hbu = json[:entries].first
      expect(hbu[:id]).not_to be_blank
      expect(hbu[:name]).not_to be_blank
      expect(hbu[:address]).not_to be_blank
      expect(hbu[:address]).to be_a(String)
      expect(hbu[:city]).not_to be_blank
      expect(hbu[:phone]).not_to be_blank
      expect(hbu[:geocode][:lat]).not_to be_blank
      expect(hbu[:geocode][:lat]).to be_a(Float)
      expect(hbu[:geocode][:long]).not_to be_blank
      expect(hbu[:geocode][:long]).to be_a(Float)
      expect(hbu[:scores][:size]).not_to be_blank
      expect(hbu[:scores][:adaptation_for_seniors]).not_to be_blank
      expect(hbu[:scores][:medical_equipment]).not_to be_blank
      expect(hbu[:scores][:medicine]).not_to be_blank
    end
  end
end
