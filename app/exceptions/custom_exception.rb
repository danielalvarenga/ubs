# frozen_string_literal: false

# How to use
# CustomException.new(:route_not_found)
# CustomException.new(exception)
# CustomException.new(error_key: :timeout, exception: e)
# CustomException.new(error_key: 'error_key_name', message: 'Perdeu playboy', log_message: 'deu merda'...)
class CustomException < StandardError

  attr_reader :error_key, :code, :http_status, :log, :log_level, :log_message, :data, :location
  attr_reader :log_msg, :log_error_executed

  def initialize(args)
    args = check_args(args)

    message = args.fetch(:message) { I18n.t("errors.#{@error_key}.message", args) }
    super(message)

    if get_locale_error
      set_attributes(args)
      log_error(args)
    end
  end

  def check_args(args)
    if args.is_a?(Symbol) || args.is_a?(String)
      @error_key = args
      return {}
    end

    raise(KeyError, 'Error key is not identified in argument') unless args.respond_to?(:fetch) || args.is_a?(Exception)

    args = check_exception(args)

    @error_key = args.fetch(:error_key) { raise(KeyError, 'Error key is not identified in argument') }
    @error_key = args.fetch(:error_key).downcase
    args
  end

  def check_exception(args)
    if args.is_a?(Exception)
      return {
        error_key: :internal_server_error,
        log_message: "#{args.class.name}|#{args.message}",
        location: args.backtrace_locations.try(:first)
      }
    end

    if args.respond_to?(:fetch) && args[:exception]
      args[:log_message] = "#{args[:exception].class}|#{args[:exception].message}"
      args[:location] = args[:exception].backtrace_locations.try(:first)
    end

    args
  end

  def get_locale_error
    i18n_error = I18n.t("errors.#{@error_key}")
    raise(KeyError, 'Error key is not identified in locale') unless i18n_error.respond_to?(:fetch)

    @error = OpenStruct.new(i18n_error)
  end

  def set_attributes(args)
    @code = @error.code
    @http_status = @error.http_status if @error.http_status
    @data = args.fetch(:data) { @error.data || nil }
    @location = args.fetch(:location) { nil }
  end

  def log_error(args)
    @log = args.fetch(:log) { @error.log }
    return unless @log

    @log_level = args.fetch(:log_level) { @error.log_level }
    @log_message = args.fetch(:log_message) { I18n.t("errors.#{@error_key}.log_message", args) }

    @log_msg = "error_key=#{@error_key}"
    @log_msg << "|message=[#{@log_message}]" if @log_message
    @log_msg << "|location=[#{@location}]" if @location
    Rails.logger.send(@log_level, @log_msg)
    @log_error_executed = true
  end

end
