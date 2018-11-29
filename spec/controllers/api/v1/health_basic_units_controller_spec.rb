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
        expect(json[:entries].first[:id]).to eq(hbu.id)
        expect(json[:entries].first[:geocode][:lat]).to eq(hbu.address.latitude)
        expect(json[:entries].first[:geocode][:long]).to eq(hbu.address.longitude)
      end
    end

    it 'returns serialized entries' do
      get :index
      hbu = HealthBasicUnit.find(json[:entries].first[:id])
      entry = json[:entries].first
      expect(entry[:name]).to eq(hbu.name)
      expect(entry[:address]).to eq(hbu.address.street)
      expect(entry[:city]).to eq(hbu.address.city)
      expect(entry[:phone]).to eq(hbu.phone)
      expect(entry[:geocode][:lat]).to eq(hbu.address.latitude)
      expect(entry[:geocode][:long]).to eq(hbu.address.longitude)
      expect(entry[:scores][:size]).to eq(hbu.scores.size)
      expect(entry[:scores][:adaptation_for_seniors]).to eq(hbu.scores.adaptation_for_seniors)
      expect(entry[:scores][:medical_equipment]).to eq(hbu.scores.medical_equipment)
      expect(entry[:scores][:medicine]).to eq(hbu.scores.medicine)
    end
  end
end
