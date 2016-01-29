# frozen_string_literal: true

require './url_shortener/app'

module UrlShortener
  # SharedLogger is a simple module to make logging
  # across variuos objects easier

  module SharedLogger
    def log_info(message)
      logger.info message
      output.flush
    end

    private

    def logger
      @logger ||= Logger.new(output)
    end

    def output
      App.settings.log_output
    end
  end
end # module UrlShortener
