# frozen_string_literal: true
require 'open-uri'
require 'net/http'
require 'csv'

class Api::V1::HealthBasicUnitImporterService < Api::V1::ApiService

  attr_accessor :csv_url, :folder_path, :file_name

  SCORES = {
    'Desempenho muito acima da média' => 3,
    'Desempenho acima da média' => 2,
    'Desempenho mediano ou  um pouco abaixo da média' => 1
  }.freeze

  def initialize(csv_url)
    @csv_url = csv_url if valid_url?(csv_url)
    @folder_path = 'tmp/csvs'
    @file_name = 'ubs.csv'
  end

  def valid_url?(str_url)
    uri = URI.parse(str_url)
    return true if uri && !uri.host.nil?

    raise CustomException.new(error_key: :invalid_csv_url, csv_url: str_url)
  rescue URI::InvalidURIError
    raise CustomException.new(error_key: :invalid_csv_url, csv_url: str_url)
  end

  def import
    download_csv
    read_csv
  end

  def download_csv
    system('mkdir', '-p', @folder_path)
    file_path = "#{@folder_path}/#{file_name}"
    File.delete(file_path) if File.exist?(file_name)
    open(file_path, 'wb') { |file| file << open(@csv_url).read }
  rescue StandardError => e
    raise CustomException.new(error_key: :download_csv_fail, exception: e)
  end

  def read_csv
    file_path = "#{@folder_path}/#{file_name}"
    csv_text = File.read(file_path)
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      create_or_update_hbu(row)
    end
  rescue StandardError => e
    raise CustomException.new(error_key: :read_csv_fail, exception: e)
  end

  def create_or_update_hbu(row)
    hbu = HealthBasicUnit.where(cnes_code: row['cod_cnes']).first
    hbu ||= HealthBasicUnit.new
    hbu.name = row['nom_estab']
    hbu.cnes_code = row['cod_cnes']
    hbu.phone = row['dsc_telefone']
    hbu.address = create_or_update_address(hbu.address, row)
    hbu.scores = create_or_update_scores(hbu.scores, row)
    hbu.save!
  end

  def create_or_update_address(address, row)
    address ||= Address.new
    address.street = row['dsc_endereco']
    address.neighborhood = row['dsc_bairro']
    address.city = row['dsc_cidade']
    address.county_code = row['cod_munic']
    address.latitude = row['vlr_latitude']
    address.longitude = row['vlr_longitude']
    address
  end

  def create_or_update_scores(scores, row)
    scores ||= Scores.new
    scores.size = SCORES[row['dsc_estrut_fisic_ambiencia']]
    scores.adaptation_for_seniors = SCORES[row['dsc_adap_defic_fisic_idosos']]
    scores.medical_equipment = SCORES[row['dsc_equipamentos']]
    scores.medicine = SCORES[row['dsc_medicamentos']]
    scores
  end

end
