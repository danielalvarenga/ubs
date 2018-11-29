# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::HealthBasicUnitImporterService do
  let!(:csv_url) { 'http://repositorio.dados.gov.br/saude/unidades-saude/unidade-basica-saude/ubs.csv' }

  subject { Api::V1::HealthBasicUnitImporterService.new(csv_url) }

  context 'is valid' do
    it 'when receive csv url' do
      expect(subject.csv_url).to eq(csv_url)
    end

    it 'when start importation' do
      expect(subject).to receive(:download_csv).with(no_args)
      expect(subject).to receive(:read_csv).with(no_args)
      subject.import
    end

    it 'when download csv', :vcr do
      file_path = "#{subject.folder_path}/#{subject.file_name}"
      File.delete(file_path) if File.exist?(file_path)
      subject.download_csv
      expect(File.exist?(file_path)).to be_truthy
    end

    it 'when create health basic units per csv lines', :vcr do
      subject.folder_path = 'spec/support/files'
      expect do
        subject.read_csv
      end.to change(HealthBasicUnit, :count).by(5).and change(Address, :count).by(5).and change(Scores, :count).by(5)
    end

    it 'when not create new health basic unit if exists', :vcr do
      create(:complete_hbu, cnes_code: '3492')
      subject.folder_path = 'spec/support/files'
      expect do
        subject.read_csv
      end.to change(HealthBasicUnit, :count).by(4).and change(Address, :count).by(4).and change(Scores, :count).by(4)
    end

    it 'when update health basic unit with existing cnes code', :vcr do
      hbu = create(:complete_hbu, cnes_code: '3492')
      subject.folder_path = 'spec/support/files'
      subject.read_csv
      hbu.reload
      expect(hbu.name).to eq('US OSWALDO DE SOUZA')
      expect(hbu.phone).to eq('7931791326')
      expect(hbu.address.street).to eq('TV ADALTO BOTELHO')
      expect(hbu.address.city).to eq('Aracaju')
      expect(hbu.address.county_code).to eq('280030')
      expect(hbu.address.neighborhood).to eq('GETULIO VARGAS')
      expect(hbu.address.latitude.to_f).to eq(-10.9112370014188)
      expect(hbu.address.longitude.to_f).to eq(-37.0620775222768)
      expect(hbu.scores.size).to eq(2)
      expect(hbu.scores.adaptation_for_seniors).to eq(3)
      expect(hbu.scores.medical_equipment).to eq(1)
      expect(hbu.scores.medicine).to eq(2)
    end
  end

  context 'is invalid' do
    it 'when return error if csv url is not a url' do
      expect do
        Api::V1::HealthBasicUnitImporterService.new('abc')
      end.to raise_error(CustomException, "Invalid csv url: 'abc'")
    end
  end
end
