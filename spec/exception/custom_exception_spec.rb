# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomException do
  let(:valid_error) do
    {
      error_key: 'route_not_found',
      code: 'ZL',
      message: 'some message',
      log: true,
      log_level: 'debug',
      log_message: 'some log message',
      location: '/path/file:10',
      data: [{ key: 'value' }],
      http_status: 409
    }
  end

  context 'is valid' do
    it 'when there is error key mapped in locale' do
      error_key = :internal_server_error
      error = I18n.t("errors.#{error_key}")
      custom_exception = CustomException.new(error_key)
      expect(custom_exception.code).to eq(error[:code])
      expect(custom_exception.http_status).to eq(error[:http_status])
      expect(custom_exception.log).to eq(error[:log])
      expect(custom_exception.data).to be_nil
      expect(custom_exception.log_level).to eq(error[:log_level])
      expect(custom_exception.log_msg).to eq(
        "error_key=#{error_key}|message=[#{error[:log_message]}]"
      )
      expect(custom_exception.log_error_executed).to be_truthy
    end

    it 'when override values' do
      error_key = :route_not_found
      error = I18n.t("errors.#{error_key}")
      custom_exception = CustomException.new(valid_error)
      expect(custom_exception.code).to eq(error[:code])
      expect(custom_exception.http_status).to eq(error[:http_status])
      expect(custom_exception.log).to eq(valid_error[:log])
      expect(custom_exception.data.first[:key]).to eq(valid_error[:data].first[:key])
      expect(custom_exception.log_level).to eq(valid_error[:log_level])
      expect(custom_exception.log_msg).to eq(
        "error_key=#{valid_error[:error_key]}|message=[#{valid_error[:log_message]}]|location=[#{valid_error[:location]}]"
      )
      expect(custom_exception.log_error_executed).to be_truthy
    end

    it 'when receive error key and exception' do
      error_key = :unauthorized
      error = I18n.t("errors.#{error_key}")
      error_message = 'some message'
      raise error_message
    rescue RuntimeError => e
      custom_exception = CustomException.new(error_key: error_key, exception: e)
      expect(custom_exception.code).to eq(error[:code])
      expect(custom_exception.http_status).to eq(error[:http_status])
      expect(custom_exception.log).to eq(error[:log])
      expect(custom_exception.log_level).to eq(error[:log_level])
      expect(custom_exception.log_msg).to eq(
        "error_key=#{error_key}|message=[RuntimeError|#{error_message}]|location=[#{e.backtrace_locations.first}]"
      )
      expect(custom_exception.log_error_executed).to be_truthy
    end

    it 'when return internal server error if receive exception only' do
      error_key = :internal_server_error
      error = I18n.t("errors.#{error_key}")
      error_message = 'some message'
      raise error_message
    rescue RuntimeError => e
      custom_exception = CustomException.new(e)
      expect(custom_exception.code).to eq(error[:code])
      expect(custom_exception.http_status).to eq(error[:http_status])
      expect(custom_exception.log).to eq(error[:log])
      expect(custom_exception.log_level).to eq(error[:log_level])
      expect(custom_exception.log_msg).to eq(
        "error_key=#{error_key}|message=[RuntimeError|#{error_message}]|location=[#{e.backtrace_locations.first}]"
      )
      expect(custom_exception.log_error_executed).to be_truthy
    end
  end

  context 'is invalid' do
    it "when there isn't error key mapped in locale" do
      expect { # rubocop:disable all
        CustomException.new(:not_mapped_error_key)
      }.to raise_error(KeyError, 'Error key is not identified in locale')
    end

    it "when there isn't error key or Exception" do
      expect { # rubocop:disable all
        CustomException.new(key: 'value')
      }.to raise_error(KeyError, 'Error key is not identified in argument')
    end

    it "when isn't a Hash or Exception" do
      expect { # rubocop:disable all
        CustomException.new
      }.to raise_error(ArgumentError)
    end
  end
end
